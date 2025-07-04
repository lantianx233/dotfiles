#!/usr/bin/env bash

set -euo pipefail

# ---------- 终端颜色 ----------
OK="$(tput setaf 2)[OK]$(tput sgr0)"
INFO="$(tput setaf 6)[INFO]$(tput sgr0)"
WARN="$(tput setaf 3)[WARN]$(tput sgr0)"
ERR="$(tput setaf 1)[ERR]$(tput sgr0)"

# ---------- 脚本配置 ----------
REPO_ROOT="$HOME/dotfiles"       # flake 根目录
ASSETS_DIR="$REPO_ROOT/assets"          # 资产文件（.zshrc、fastfetch 等）
LOG="$HOME/post-install.log"            # 日志输出
exec &> >(tee -a "$LOG")                # 同时写屏幕和日志

echo -e "${INFO} 开始执行 post-install 脚本…\n日志写入：$LOG\n"

# ---------- 12. zsh 配置 ----------
echo -e "${INFO} 部署 zsh 配置"
if [[ -f "$HOME/.zshrc" && ! -f "$HOME/.zshrc-backup" ]]; then
  cp -a "$HOME/.zshrc" "$HOME/.zshrc-backup"
  echo "${OK} 备份原 .zshrc -> .zshrc-backup"
fi
cp -f "$ASSETS_DIR/.zshrc" "$HOME/.zshrc"
echo "${OK} 新 .zshrc 已覆盖"

# ---------- 13. GTK 主题 & 图标 ----------
echo -e "\n${INFO} 安装 GTK 主题与图标"
TMP_DIR="$(mktemp -d)"
git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git "$TMP_DIR"
if [[ -x "$TMP_DIR/auto-extract.sh" ]]; then
  (
    cd "$TMP_DIR"
    chmod +x auto-extract.sh
    ./auto-extract.sh
  )
  echo "${OK} 主题已解压到 ~/.themes 与 ~/.icons"
else
  echo "${WARN} auto-extract.sh 未找到，跳过解压"
fi
rm -rf "$TMP_DIR"

# ---------- 14. 补充常用配置目录 ----------
echo -e "\n${INFO} 检查常用 ~/.config 子目录"
for DIR in gtk-3.0 Thunar xfce4; do
  if [[ ! -d "$HOME/.config/$DIR" && -d "$ASSETS_DIR/$DIR" ]]; then
    cp -r "$ASSETS_DIR/$DIR" "$HOME/.config/"
    echo "${OK} 拷贝 $DIR → ~/.config/"
  else
    echo "${INFO} ~/.config/$DIR 已存在，跳过"
  fi
done

# ---------- 16. Hyprland-Dots ----------
echo -e "\n${INFO} 同步 Hyprland-Dots"
DOTS_DIR="$HOME/Hyprland-Dots"
if [[ -d "$DOTS_DIR/.git" ]]; then
  git -C "$DOTS_DIR" pull --ff-only
else
  git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots.git "$DOTS_DIR"
fi
chmod +x "$DOTS_DIR/copy.sh"
"$DOTS_DIR/copy.sh"
echo "${OK} Hyprland dotfiles 部署完成"

# ---------- 17. Fastfetch 配置 ----------
echo -e "\n${INFO} 布置 fastfetch 壁纸 / 配置"
if [[ ! -f "$HOME/.config/fastfetch/nixos.png" ]]; then
  mkdir -p "$HOME/.config/fastfetch"
  cp -r "$ASSETS_DIR/fastfetch/"* "$HOME/.config/fastfetch/"
  echo "${OK} fastfetch 素材已拷贝"
else
  echo "${INFO} fastfetch 已存在，跳过"
fi

# ---------- 收尾 ----------
echo -e "\n${OK} post-install.sh 完成！"
