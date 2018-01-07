git config --system core.autoCRLF false
git config --system user.name  root
git config --system user.email root@super-computer
git config --unset-all credential.helper
git config --global --unset-all credential.helper
git config --global credential.helper manager
git config --global credential.useHttpPath true
pause
