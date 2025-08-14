# システムコマンド（Darwin/macOS）

## 基本ユーティリティ

### ファイル操作
```bash
# ディレクトリ一覧表示
ls -la

# ディレクトリ移動
cd /path/to/directory

# ファイル検索
find . -name "*.tf" -type f

# ファイル内容検索
grep -r "search_term" .

# 現在のディレクトリパス表示
pwd
```

### Git操作
```bash
# 現在のブランチとステータス確認
git status

# 変更内容確認
git diff

# コミット履歴確認
git log --oneline -10

# ブランチ一覧
git branch -a

# リモート更新
git fetch origin

# ブランチ切り替え
git checkout branch-name
```

### ファイル内容確認
```bash
# ファイル内容表示
cat filename

# ファイル先頭表示
head -20 filename

# ファイル末尾表示
tail -20 filename

# ページング表示
less filename
```

### プロセス・システム情報
```bash
# プロセス確認
ps aux | grep process_name

# ディスク使用量
df -h

# メモリ使用量
top -l 1 | head -10

# システム情報
uname -a
```

## Darwin固有の特徴

### パッケージ管理
```bash
# Homebrewでパッケージ管理
brew install package_name
brew list
brew update
```

### Docker操作
```bash
# Dockerコンテナ実行
docker run --rm -v "$(pwd):$(pwd)" -w "$(pwd)" image_name

# Dockerイメージ一覧
docker images

# Dockerコンテナ一覧
docker ps -a
```

## ネットワーク・接続
```bash
# ネットワーク接続確認
ping hostname

# ポート確認
netstat -an | grep port_number

# DNS確認
nslookup hostname
```