# 🐚 `shellConfig` – Final Form of Your Shell

> _“Your shell config is either ✨ divine ✨ or a war crime. Choose wisely.”_ – Sun Tzu, probably

---

## 📦 What's in the shellConfig

Tired of dotfile gatekeeping? Say less. This is your all-in-one, pre-configured terminal glow-up. No weird bashrc rituals. Just vibes.

| 🧩 Tool          | 💅 Description                                                                              |
| ---------------- | ------------------------------------------------------------------------------------------- |
| 🐱 `ndbat`       | `cat` but with syntax frosting. Comes with that TwoDark sauce (aliases: `cat`).             |
| 📉 `ndbottom`    | `htop` if it drank Monster and listened to vaporwave (aliases: `btm`).                      |
| 🏗 `build-all`   | Builds all flake packages in one go. Because you are inevitable.                            |
| 🌍 `ndenv`       | `ripgrep`, `fzf`, `uutils-coreutils-noprefix`, the usual suspects – fully loaded.           |
| ⚡ `ndfastfetch` | Like `neofetch` but faster, cooler, and actually useful (aliases: `neofetch`, `fastfetch`). |
| 🧙 `ndgit`       | Auto-configured and ready to `git gud` (aliases: `git`).                                    |
| 📚 `ndpandoc`    | Converts everything. PDF? HTML? Markdown? Your ex’s apology letter? (aliases: `pandoc`)✅   |
| 🌟 `ndstarship`  | The prompt that makes other prompts feel underdressed (aliases: `starship`).                |
| 🐚 `ndzsh`       | Plugin-packed. Auto-sourced. Ready to flex (aliases: `zsh`).                                |
| 🧩 `default`     | Installs everything. One command. Infinite swagger.                                         |

> 💡 Built with [`Nix`](https://nixos.org/) because reproducibility is sexy. 💅
> _And no, it doesn’t break every update. You’re thinking of `npm`._ 😬

---

## ⚡ How to Instantly Become Cool

Wanna flex in your terminal like it’s 2077?

### 🐚 ZSH Only

```bash
nix shell .#ndzsh
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

### 🦇 Bat

```nix
pkgs.ndbat.override {
   theme = "TwoDark";
}
```

### ⬇️ Bottom

```nix
pkgs.ndbtm.override {
  avg_cpu = true;
  battery = true;
  colors = { low_battery_color = "red";};
  rate = "1s";
}
```

### 💻 Fastfetch

```nix
pkgs.ndfastfetch.override {
  aliases = ["fastefetch" "ff"];
  theme = ''
    $5.-----------------------------.
    | ---      NO SERVER?    ---  |
    '-----------------------------'
    ⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇
    ⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀
    ⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀
    ⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀
    ⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  '';
}
```

### 🗄️ Git

```nix
pkgs.ndgit.override {
  config = {
    gitconfig = {
      alias = {
        br = "branch";
        pl = "pull";
        pu = "push";
      };
      core.pager =  "${pkgs.delta}/bin/delta"
      user = {
        name = "Your Real Cool Name";
        email = "you@the-internet.cool";
        signingkey = "0xBEEFCAFE";
      };
    };
    gitignore = [
      "*.swp"
      ".DS_Store"
      ".o"
      "result"
      "target/"
    ];
  };
}
```

### 🔧 JQ

```nix
pkgs.ndjq.override {
  theme = {
    false = "0;31";
    null = "1;35";
    true = "0;32";
  };
}

```

### 🖋 Pandoc

```nix
pkgs.ndpandoc.override {
  config = {
    metadata = {
      author = "You, the myth";
      language = "en";
      toc = true;
    };
  };
}
```

### 🚀 Starship

```nix
pkgs.ndstarship.override {
  theme = {
    fg0 = "#181818";
    p0 = "#ff767a";
    p1 = "#ff9268";
    p2 = "#ffd254";
    p3 = "#86BBD8";
    p4 = "#45ace7";
    p5 = "#da84e4";
    green = "#80dc7e";
    purple = "#da84e4";
    red = "#ff767a";
  };
}
```

### 🐚 ZSH

```nix
pkgs.ndzsh.override {
  config = {
    aliases = {
      cargo-in = "${pkgs.cargo}/bin/cargo install";
    };
    extraRC = ''
      echo "This will be added to the generated .zshenv"
    '';
    extraPackages = [
      pkgs.tmux
    ];
  };
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

```

```

```

```

```

```
