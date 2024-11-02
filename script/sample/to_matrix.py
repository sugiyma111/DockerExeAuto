import pandas as pd

# CSVファイルを読み込み
input_df = pd.read_csv('library-list.csv')

# 1列目を基準に重複行を削除
input_df = input_df.drop_duplicates(subset=input_df.columns[0], keep='first')

# "java" を含むエントリを 'Libraries' から削除
def remove_java_related(names):
    # "java" が含まれるエントリを削除
    filtered_names = [name.strip() for name in str(names).split(',') if 'java' not in name]
    return ', '.join(filtered_names)

input_df['Libraries'] = input_df['Libraries'].apply(remove_java_related)

# ユニークなライブラリ名を取得
unique_libraries = set()
for libraries in input_df['Libraries'].dropna():
    unique_libraries.update(lib.strip() for lib in libraries.split(','))

# 'Name' をインデックス、ユニークなライブラリ名を列として持つデータフレームを初期化
result_df = pd.DataFrame(0, index=input_df['Name'], columns=sorted(unique_libraries))

# 各行に対して、該当するライブラリがある場合に 1 を設定
for idx, row in input_df.iterrows():
    test_name = row['Name']
    libraries = [lib.strip() for lib in str(row['Libraries']).split(',') if pd.notna(row['Libraries'])]
    result_df.loc[test_name, libraries] = 1

# 結果をCSVファイルとして保存
result_df.to_csv('matrix.csv', index=True)

print("作成された表が 'matrix.csv' として保存されました。")
