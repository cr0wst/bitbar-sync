# BitBar Sync
Script for syncing a directory with a remote server that utilizes BitBar to display shared files.
![See it in action](screenshot.png)
Originally created to handle grabbing screenshots and sharing them with others.

## Installation
In order to get notifications you'll need to install [terminal-notifier](https://github.com/julienXX/terminal-notifier).

First, clone or copy the repository contents to your computer.

Second, copy `.example.config.sync.yml` into the `plugin` directory as `.config.sync.yml`
```bash
cp .example.config.sync.yml plugin/.config.sync.yml
```

Third, open the file in your favorite text editor and define the configuration variables.

Fouth, copy the contents of the `plugin` directory to your BitBar plugin folder.  Alternatively, you can define a symbolic link.
```bash
ln -s ~/Repos/bitbar-sync/plugin/* .
ln -s ~/Repos/bitbar-sync/plugin/.config.sync.yml .
```

You can modify the name of `sync.10m.rb` to indicate how often you would like BitBar to run it.

### Rsync Setup
In order to setup rsync you'll need to make sure you have an SSH key and configuration setup on your Mac.

Example:

In `~/.ssh/config`
```bash
Host deploy.example.com
  User deployer
  IdentityFile ~/.ssh/deployer_rsa
```

The private key for this account is stored in `~/.ssh/deployer_rsa`

## Usage
You can use a task runner such as [Alfred](https://www.alfredapp.com/) to trigger the script with the `capture` argument to initiate a screen capture.

Alternatively, you can select the `capture` option from BitBar.  Once the screenshot has been captured, the sync event will be triggered and the URL will be copied to your clipboard.

You can also add any files you want to your `SCREENSHOT_DIRECTORY` and use the `Sync Directory` option to rsync the files.

## Delete
Rsync is being used with the `--delete` flag so files that are deleted should be deleted from the remote server.  It has also been instructed to `--exlude index.html` so you can block the directory root on your server.

## Thanks
- [Sara Bine](https://github.com/sbine) for the initial bash script that inspired this.

## Contribution
I don't write a lot of Ruby and BitBar is limited in that it's difficult to bring in external libraries.  Contributions are welcome!