# Requisitos para scripts MD/PDF

Dependências necessárias para rodar `md2pdf.sh`, `md2pdf_mail.sh` e `mail_file.sh`.

## Conversão Markdown para PDF

### Pandoc
```bash
# Debian/Ubuntu
sudo apt install pandoc

# Arch Linux
sudo pacman -S pandoc

# Fedora
sudo dnf install pandoc

# macOS
brew install pandoc
```

### LaTeX (XeTeX)
```bash
# Debian/Ubuntu
sudo apt install texlive-xetex texlive-fonts-recommended

# Arch Linux
sudo pacman -S texlive-xetex

# Fedora
sudo dnf install texlive-xetex

# macOS
brew install --cask mactex
```

### Fontes DejaVu
```bash
# Debian/Ubuntu
sudo apt install fonts-dejavu

# Arch Linux
sudo pacman -S ttf-dejavu

# Fedora
sudo dnf install dejavu-sans-fonts dejavu-sans-mono-fonts

# macOS
brew install --cask font-dejavu
```

## Envio de Email

Instale **pelo menos um** dos seguintes:

### Mutt (recomendado)
```bash
# Debian/Ubuntu
sudo apt install mutt

# Arch Linux
sudo pacman -S mutt

# Fedora
sudo dnf install mutt

# macOS
brew install mutt
```

### Mailx (alternativa)
```bash
# Debian/Ubuntu
sudo apt install mailutils

# Arch Linux
sudo pacman -S s-nail

# Fedora
sudo dnf install mailx
```

### Sendmail (alternativa)
```bash
# Debian/Ubuntu
sudo apt install postfix

# Arch Linux
sudo pacman -S postfix

# Fedora
sudo dnf install postfix
```

## Instalação completa (Debian/Ubuntu)

```bash
sudo apt install pandoc texlive-xetex texlive-fonts-recommended fonts-dejavu mutt
```

## Instalação completa (Arch Linux)

```bash
sudo pacman -S pandoc texlive-xetex ttf-dejavu mutt
```

## Verificação

```bash
command -v pandoc && echo "pandoc OK"
command -v xelatex && echo "xelatex OK"
fc-list | grep -i dejavu && echo "DejaVu fonts OK"
command -v mutt || command -v mailx || command -v sendmail && echo "email OK"
```
