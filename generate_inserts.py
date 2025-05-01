import pandas as pd
import re

# 1. Lee el CSV (ajusta nombre/ruta si es necesario)
df = pd.read_csv(
    'club-games (1).csv',
    parse_dates=['fecha'],
    date_parser=lambda x: pd.to_datetime(x, format='%Y-%m-%d'),
    dtype={'hora': str}
)
df['hora'] = df['hora'].str.strip()

# 2. Construye cada DataFrame de tu modelo

# JUGADOR
jugantes = df['jugadores'].str.split('; ').explode().str.strip()
ganadores = df['resultado'].str.replace(' ganó', '', regex=False)
jugadores_df = pd.Series(
    pd.concat([jugantes, ganadores]).unique(),
    name='nombre_jugador'
).to_frame()

# JUEGO y COPIA_JUEGO
juegos_df = pd.Series(df['juego'].unique(), name='nombre_juego').to_frame()
copia_juego_df = (
    df[['copia_juego','juego']]
    .drop_duplicates()
    .rename(columns={'copia_juego':'id_juego','juego':'nombre_juego'})
)

# EXPANSION y COPIA_EXPANSION
exp_rows, copia_rows = [], []
for _, r in df.iterrows():
    if pd.isna(r['expansiones']) or not r['expansiones'].strip():
        continue
    for part in re.split(r'\);\s*', r['expansiones']):
        p = part.strip().rstrip(')')
        name = p.split(' (coste:')[0].strip()
        precio = int(re.search(r'coste:\s*([0-9]+)€', p).group(1))
        id_exp = int(re.search(r'copia:\s*([0-9]+)', p).group(1))
        exp_rows.append({'nombre_exp': name, 'nombre_juego': r['juego']})
        copia_rows.append({'id_exp': id_exp, 'nombre_exp': name, 'precio': precio})

expansion_df = pd.DataFrame(exp_rows).drop_duplicates()
copia_expansion_df = pd.DataFrame(copia_rows).drop_duplicates()

# PERSONAL
personal_df = pd.Series(
    df['personal'].dropna().unique(),
    name='nombre_personal'
).to_frame()

# PARTIDA
partida_df = (
    df[['partida_id','copia_juego','juego']]
    .drop_duplicates()
    .rename(columns={'copia_juego':'id_juego','juego':'nombre_juego'})
)

# JUEGA
juega_df = (
    df.set_index('partida_id')['jugadores']
      .str.split('; ')
      .explode()
      .reset_index()
      .rename(columns={'partida_id':'id_partida','jugadores':'nombre_jugador'})
)

# GANA
gana_df = (
    df[['partida_id','resultado']]
      .assign(nombre_jugador=lambda d: d['resultado'].str.replace(' ganó',''))
      .rename(columns={'partida_id':'id_partida'})
      [['nombre_jugador','id_partida']]
)

# ORGANIZA
organiza_df = df[['personal','partida_id','fecha','hora']].rename(
    columns={'personal':'nombre_personal','partida_id':'id_partida'}
)

# UTILIZA
utiliza_rows = []
for _, r in df.iterrows():
    if pd.isna(r['expansiones']) or not r['expansiones'].strip():
        continue
    for part in re.split(r'\);\s*', r['expansiones']):
        p = part.strip().rstrip(')')
        name = p.split(' (coste:')[0].strip()
        id_exp = int(re.search(r'copia:\s*([0-9]+)', p).group(1))
        utiliza_rows.append({
            'id_partida': r['partida_id'],
            'id_exp': id_exp,
            'nombre_exp': name
        })
utiliza_df = pd.DataFrame(utiliza_rows).drop_duplicates()

# 3. Función helper para escapar valores en SQL
def esc(val):
    if pd.isna(val): 
        return 'NULL'
    if isinstance(val, str):
        return "'" + val.replace("'", "\\'") + "'"
    if isinstance(val, pd.Timestamp):
        return "'" + val.date().isoformat() + "'"
    return str(val)

# 4. Genera un fichero INSERT por tabla
tabla_dfs = {
    'JUGADOR':         (jugadores_df,       ['nombre_jugador']),
    'JUEGO':           (juegos_df,          ['nombre_juego']),
    'COPIA_JUEGO':     (copia_juego_df,     ['id_juego','nombre_juego']),
    'EXPANSION':       (expansion_df,       ['nombre_exp','nombre_juego']),
    'COPIA_EXPANSION': (copia_expansion_df, ['id_exp','nombre_exp','precio']),
    'PERSONAL':        (personal_df,        ['nombre_personal']),
    'PARTIDA':         (partida_df,         ['partida_id','id_juego','nombre_juego']),
    'JUEGA':           (juega_df,           ['nombre_jugador','id_partida']),
    'GANA':            (gana_df,            ['nombre_jugador','id_partida']),
    'ORGANIZA':        (organiza_df,        ['nombre_personal','id_partida','fecha','hora']),
    'UTILIZA':         (utiliza_df,         ['id_partida','id_exp','nombre_exp']),
}

for table, (df_table, cols) in tabla_dfs.items():
    filename = f'inserts_{table}.sql'
    with open(filename, 'w', encoding='utf-8') as f:
        for _, row in df_table.iterrows():
            values = ",".join(esc(row[c]) for c in cols)
            f.write(f"INSERT INTO {table} ({','.join(cols)}) VALUES ({values});\n")
    print(f"✔️  {filename}  ({len(df_table)} registros)")
