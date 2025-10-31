# Claude Code Configuration

## Summary

This is a WIP approach to managing shared "user" level Claude Code configuration. Currently, it only contributes `skills` but could link custom `commands`, etc... in the future.

## Use

The following will clone this repository to your `src` directory and create a symbolic link of each directory in `./skills` to your `~/.claude/skills` directory.

```bash
cd ~/src
git clone git@github.com:tim-kuntz/claude.git
cd claude
./link_skills.sh
```

You will need to restart `claude` to have it pick up the newly added skills.

## Dependencies

* The Atlassian CLI `acli` is required to use the `jira-skill`. It can be installed with Homebrew. The `acli` [How to get started](https://developer.atlassian.com/cloud/acli/guides/how-to-get-started/) page also provides instructions on how to authenticate with an API token.

```bash
brew tap atlassian/homebrew-acli
brew install acli
acli jira auth login --web
```

