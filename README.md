# 🐚 shellConfig – The Final Form of Your Shell

> Because defaults are boring, and your shell deserves drip. 😎

## ✨ What's in the Box?

All your favorite shell tools, but **pre-configured**, **pretty**, and ready to **vibe**.

| 🔧 Tool            | 🔍 Description                                                        |
| ------------------ | --------------------------------------------------------------------- |
| 🐱 **bat**         | Like `cat`, but it _glows_. TwoDark theme pre-loaded.                 |
| 📊 **bottom**      | The cooler `htop`. Comes with custom sauce.                           |
| 🛠 **build-all**   | Run `build-all` to build _all_ flake packages. Like a boss.           |
| 🌍 **environment** | Your CLI cheat codes: `ripgrep`, `coreutils`, `fzf`, and more.        |
| 🚀 **fastfetch**   | System info at lightspeed – now with custom logos.                    |
| 🧙 **git**         | Git good™ – with your username already set.                          |
| 📄 **pandoc**      | Convert all the things. With your name on it.                         |
| 🌟 **starship**    | Prompt game: maxed out. Just works™.                                 |
| 🐚 **zsh**         | Fully armed ZSH config. Just source `$out/share/SOURCE_ME.sh` and go. |
| 🧩 **default**     | Brings it _all_ together. Installs everything.                        |

## 🧪 Usage

With flakes:

```bash
nix shell .#zsh
```

Or get everything:

```bash
nix shell .#default
```

## ⚙️ Configuration

The packages `git` and `pandoc` can and should be overridden for your username

- Git

```nix
pkgs.git.override {
    user.name = "<YOUR USERNAME>";
    user.email = "<YOUR EMAIL>";
    user.signingkey = "<YOUR SIGNINGKEY>";
}
```

- Pandoc

```nix

pkgs.pandoc.override { author = "<YOUR NAME>"; }
```

## 🧙‍♂️ Why?

Because spending 4 hours tweaking your dotfiles is a rite of passage,
but doing it every time is a crime.

---

🌀 Built with [Nix](https://nixos.org/) so you can be lazy and reproducible at the same time.
