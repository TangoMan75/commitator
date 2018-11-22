TangoMan Commitator
===================

**TangoMan Commitator** is an awesome bash script to fake git commit history.

This may be useful as pedagogic tool to teach git, train and play around with git commands without worrying about causing any real damage to an existing repository.

This may also be useful to fake contribution activity on github.com, no contribution will be created on Saturdays and Sundays for a more realistic simulation ;-)

**TangoMan Commitator** can also fake whole branches.

How to fake contributions on github
===================================

### Create new repository on github web interface

Create new repository from web interface here:
[https://github.com/new](https://github.com/new)

### Clone new repository on your local machine

```bash
$ git clone https://github.com/FooBar/repository_name.git
```

### Configure git

Configure git with **your github.com account user email** for fake contributions to show up on your profile.

```bash
$ git config user.email "you@example.com"
```

### Execute TangoMan Commitator

**Copy** `commitator.sh` and **execute script from your local repository folder**:

```bash
$ ./commitator.sh
```

Enter starting and ending dates when prompted.
> **TangoMan Commitator** allows dates as _epoch time_ (e.g: 1514761200) or _+%Y-%m-%d_ format (e.g: 2018-01-01)

### Push repository to gihub

```bash
$ git push
```

How did you do that ?
=====================

You can set any commit date with the following command:
```bash
$ git commit -m "FooBar" --date="Y-m-d_H-M-S"
```

You can change last commit date with the following command:
```bash
$ git commit --amend --date="Y-m-d_H-M-S"
```

You can also change last commit author with the following command:
```bash
$ git commit --amend --author "User Name <email@example.com>"
```

You can also use `git rebase` to change commit history:
```bash
$ git rebase -i xxxxxxxxxxxxx_commit_hash_xxxxxxxxxxxxxx
```
select `edit` in front of desired commits when rebase prompt pops up.

> If you're lost with _vim_ your can check this awesome [cheat sheet](https://vim.rtorr.com)

> In case you panic you can abort rebase with: `$ git rebase --abort`

You will then be able to change commits date and author with `git commit --amend` command with `--no-edit` parameter (to avoid edit prompt to pop up everytime)
```bash
git commit --amend --date="Y-m-d_H-M-S" --author="User Name <email@example.com>" --no-edit
```
And continue to edit next commit
```bash
git rebase --continue
```

License
=======

Copyrights (c) 2018 Matthias Morin

[![License][license-MIT]][license-url]
Distributed under the MIT license.

If you like **TangoMan Commitator** please star!
And follow me on GitHub: [TangoMan75](https://github.com/TangoMan75)
... And check my other cool projects.

[Matthias Morin | LinkedIn](https://www.linkedin.com/in/morinmatthias)

[license-MIT]: https://img.shields.io/badge/Licence-MIT-green.svg
[license-url]: LICENSE
