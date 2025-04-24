# 🐚 `shellConfig` – Final Form of Your Shell

> _“Your shell config is either ✨ divine ✨ or a war crime. Choose wisely.”_ – Sun Tzu, probably

---

## 📦 What's in the shellConfig

Tired of dotfile gatekeeping? Say less. This is your all-in-one, pre-configured terminal glow-up. No weird bashrc rituals. Just vibes.

| 🧩 Tool        | 💅 Description                                                         |
| -------------- | ---------------------------------------------------------------------- |
| 🐱 `bat`       | `cat` but with syntax frosting. Comes with that TwoDark sauce.         |
| 📉 `bottom`    | `htop` if it drank Monster and listened to vaporwave.                  |
| 🏗 `build-all` | Builds all flake packages in one go. Because you are inevitable.       |
| 🌍 `env`       | `ripgrep`, `fzf`, `coreutils`, the usual suspects – fully loaded.      |
| ⚡ `fastfetch` | Like `neofetch` but faster, cooler, and actually useful.               |
| 🧙 `git`       | Auto-configured and ready to `git gud`.                                |
| 📚 `pandoc`    | Converts everything. PDF? HTML? Markdown? Your ex’s apology letter? ✅ |
| 🌟 `starship`  | The prompt that makes other prompts feel underdressed.                 |
| 🐚 `zsh`       | Plugin-packed. Auto-sourced. Ready to flex.                            |
| 🧩 `default`   | Installs everything. One command. Infinite swagger.                    |

> 💡 Built with [`Nix`](https://nixos.org/) because reproducibility is sexy. 💅
> _And no, it doesn’t break every update. You’re thinking of `npm`._ 😬

---

## ⚡ How to Instantly Become Cool

Wanna flex in your terminal like it’s 2077?

### 🐚 ZSH Only

```bash
nix shell .#zsh
```

### 🧙 All the Toys

```bash
nix shell .#default
```

> _“It just worked, and now I fear nothing.”_ – You, right after installing this

---

## 🛠 Pimp My Config

Wanna make Git and Pandoc know your name? Override like a boss:

Wanna slap your name on it like a true CLI artist? Customize Git & Pandoc like so:

### ✍️ Git

```nix
pkgs.git.override {
  user.name = "Your Real Cool Name";
  user.email = "you@the-internet.cool";
  user.signingkey = "0xBEEFCAFE";
}
```

### 🖋 Pandoc

```nix
pkgs.pandoc.override {
  author = "You, the myth";
}
```

> _“My shell config has better branding than most startups.”_ – Also you

---

## ❓ Why Tho

Because rolling your own shell config for the 47th time this year is a cry for help.

- Tired of copying dotfiles from a blog last updated before dark mode existed?
- Bash still looking like it came from Windows 98?
- Spent more time configuring your terminal than writing code?

Same. That’s why this exists. One command, one vibe, infinite clout.

> _“I used to have impostor syndrome. Now I have `shellConfig`.”_ – Formerly Mid Developer

---

## 🧪 Nix: Like Magic, But Nerdier

This config runs on [Nix](https://nixos.org/) — the **only** package manager cool enough to be deterministic and annoying at the same time.

- 🧼 Reproducible AF – it Just Works™
- 🌀 Rollbacks faster than your last PR rejection
- 🧠 Declarative setups = actual adulting for your dotfiles

It’s like cloning your dream dev setup into every machine you touch.
Also, flakes. Because of course they're called flakes.

> _“Nix is like vim: once you suffer enough, it becomes a lifestyle.”_ – Local wizard

---

## 💀 Final Thoughts

This repo is your escape from dotfile purgatory.
One shell to rule them all. One shell to flex them.

> _“shellConfig made my terminal so hot, it overheated my ThinkPad.”_ – A Real User (probably)
