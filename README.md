# gpt in the command line

![Build status](https://github.com/netseye/gpt-shell/actions/workflows/haskell.yml/badge.svg)


A simple command-line application based on gpt-3.5-turbo-16k, designed to address some common problems encountered in daily development. Users can obtain answers directly from the command line without having to open a browser. There is no session retention mechanism, so each query is treated as a new session. This application can be integrated with existing function through piping, such as using `say` to play answers in voice format, or `bat` to display answers in Markdown format on the shell.

## Installation

```bash
  git clone https://github.com/netseye/gpt-shell.git
  cd gpt-shell
  cabal install
```

## Settings
 You'll need an OpenAI API Key assigned to the `OPENAI_API_KEY` environment variable. You can get one from [here](https://platform.openai.com/). You can set it in your `.bashrc` or `.zshrc` file like this:
```bash
  export OPENAI_API_KEY="sk-xxxxxx"
```

## Usage
```bash
  ask <prompt>
```
## Example
```bash
  ask "What is your name?"
```

## Pipe

```bash
  ask "如何shell里面获取文档第三行第二列" | bat -l md
  ask "如何shell里面获取文档第三行第二列" | say
```

## Tips
- \` in the prompt needs to be escaped with \, such as \\`

## License
  apache-2.0

