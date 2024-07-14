- windows
  ```
  winget install Neovim.Neovim
  git clone --depth 1 https://github.com/Paperweightt/neovimConfig $env:LOCALAPPDATA\nvim
  Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
  $ scoop install neovide
  ```
- mac
  ```
  brew install neovim
  git clone https://github.com/Paperweightt/neovimConfig ~/.config/nvim
  brew install --cask neovide
  ```
