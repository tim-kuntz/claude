# Claude Code Configuration

## Summary

This is a WIP approach to managing shared "user" level Claude Code configuration. Currently, it only contributes skills.

## Use

The following will clone this repository to your `src` directory and create a symbolic link of each directory in `./skills` to your `~/.claude/skills` directory.

```bash
cd ~/src
git clone git@github.com:tim-kuntz/claude.git
./link_skills.sh
```

