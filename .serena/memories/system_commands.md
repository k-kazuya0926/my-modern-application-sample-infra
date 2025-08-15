# システムコマンド（Darwin/macOS）

## 基本的なシステムコマンド

### ファイル操作
```bash
# ディレクトリ内容表示
ls -la

# ディレクトリ移動
cd /path/to/directory

# ファイル内容表示
cat filename
head -n 20 filename
tail -n 20 filename

# ファイル検索
find . -name "*.tf" -type f
find . -path "*/.terraform" -prune -o -name "*.tf" -print

# ディレクトリ作成
mkdir -p path/to/directory

# ファイル/ディレクトリコピー
cp -r source destination

# ファイル/ディレクトリ削除
rm -rf path/to/directory
```

### テキスト検索・処理
```bash
# ファイル内検索（ripgrepがある場合）
rg "pattern" --type tf

# 標準grep
grep -r "pattern" . --include="*.tf"

# 複数パターン検索
grep -E "(pattern1|pattern2)" filename

# 大文字小文字を区別しない検索
grep -i "pattern" filename

# 行番号付きで表示
grep -n "pattern" filename
```

### プロセス管理
```bash
# 実行中プロセス表示
ps aux | grep terraform

# プロセス終了
kill -9 <PID>

# バックグラウンド実行
nohup command &

# ジョブ確認
jobs
```

### ネットワーク
```bash
# ネットワーク接続確認
ping google.com

# ポート確認
netstat -an | grep :443

# DNS確認
nslookup domain.com

# HTTP確認
curl -I https://example.com
```

## Git操作

### 基本操作
```bash
# 状態確認
git status

# 変更確認
git diff
git diff --staged

# ファイル追加
git add .
git add specific-file.tf

# コミット
git commit -m "commit message"

# プッシュ
git push origin main

# プル
git pull origin main
```

### ブランチ操作
```bash
# ブランチ一覧
git branch
git branch -r

# ブランチ作成・切り替え
git checkout -b feature-branch
git switch -c feature-branch

# ブランチ切り替え
git checkout main
git switch main

# ブランチ削除
git branch -d feature-branch
```

### ログ・履歴
```bash
# コミット履歴
git log --oneline
git log --graph --oneline --all

# 特定ファイルの履歴
git log -- filename

# 変更差分
git show <commit-hash>
```

## AWS関連コマンド

### aws-vault（`aea`エイリアス）
```bash
# プロファイル一覧
aws-vault list

# 一時的なクレデンシャル取得
aea aws sts get-caller-identity

# セッション情報確認
aea aws configure list
```

### AWS CLI（aws-vault経由）
```bash
# S3バケット一覧
aea aws s3 ls

# DynamoDBテーブル一覧
aea aws dynamodb list-tables

# Lambda関数一覧
aea aws lambda list-functions

# ECRリポジトリ一覧
aea aws ecr describe-repositories
```

## Terraform関連

### Homebrewでインストールされたツール
```bash
# Terraformバージョン確認
terraform version

# terraform-docs（ドキュメント生成）
terraform-docs markdown table .

# tflint（リンター）
tflint

# terragrunt（ワークフロー管理）
terragrunt --version
```

### 状態管理
```bash
# 状態リスト
aea terraform state list

# 状態詳細表示
aea terraform state show <resource>

# 状態削除
aea terraform state rm <resource>

# 状態移動
aea terraform state mv <source> <destination>
```

## その他のツール

### パッケージ管理（Homebrew）
```bash
# パッケージ検索
brew search terraform

# パッケージ情報
brew info terraform

# パッケージ更新
brew update && brew upgrade

# インストール済みパッケージ一覧
brew list
```

### テキストエディタ
```bash
# nano（軽量エディタ）
nano filename

# vim（高機能エディタ）
vim filename

# Visual Studio Code
code .
code filename
```

### アーカイブ・圧縮
```bash
# tar圧縮
tar -czf archive.tar.gz directory/

# tar展開
tar -xzf archive.tar.gz

# zip圧縮
zip -r archive.zip directory/

# zip展開
unzip archive.zip
```

### システム情報
```bash
# macOSバージョン
sw_vers

# システム情報
uname -a

# ディスク使用量
df -h

# メモリ使用量
top -l 1 -s 0 | grep PhysMem

# CPUアーキテクチャ
arch
```

## よく使用される組み合わせ

### Terraform作業フロー
```bash
# 作業ディレクトリに移動してフルワークフロー
cd aws/environments/prod && \
aea terraform init -backend-config=backend.hcl && \
terraform validate && \
terraform fmt -recursive && \
aea terraform plan && \
aea terraform apply
```

### ファイル検索とパターンマッチ
```bash
# Terraformファイル内でmoduleを検索
find . -name "*.tf" -exec grep -l "module" {} \;

# 特定のリソースタイプを検索
rg "resource \"aws_lambda_function\"" --type tf
```

### Git作業フロー
```bash
# 変更確認→追加→コミット→プッシュ
git status && \
git diff && \
git add . && \
git commit -m "update infrastructure" && \
git push origin main
```