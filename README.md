# Cover Style Switcher (Playnite extension)

This extension lets you switch game covers and choose your preferred styles, saving and loading multiple game's cover in different slots. If you want to try different cover styles, this extension is for you! It's also useful for backing up and organizing your covers.

## Features
- You can save and load multiple game's cover in different slots.
- Covers are saved as follows:
  - `Backup/slotnumber/platform/gamename.ext` (for games without Source, like roms)
  - `Backup/slotnumber/source/gamename.ext  `   (for games with Source, like Steam, Epic, EA App, GOG)
  - `Backup/slotnumber/gameid/platform/gameid.ext`
  - `Backup/slotnumber/gameid/source/gameid.ext   `
- Covers are loaded from `gamename.ext` files. If a game has a name with special characters (`[\/\:\*?"<>|]`) it will be loaded from `gameid.ext` file.
- Covers of games with special characters in their names will be saved and named without those characters. This is for management purpose only (if you load from a slot, the cover will be loaded from `gameid.ext`). These covers will be saved here:
  - `Backup/slotnumber/special characters/platform/gamenamefixed.ext`
  - `Backup/slotnumber/special characters/source/gamenamefixed.ext`
- `gameid.ext` is always saved for better management.
- You can copy any downloaded covers to the folder structure.
- You can also manually choose a cover via Windows Explorer using the "change with Explorer" function.
- You can select multiple images at once with "change with Explorer (batch) function. The Standard "change with Explorer" can be useful if you have covers stored in different places, otherwise; the batch function should be ideal.
- `C:\Cover Styles` is the default path where covers will be placed. Edit `$global:coverPath` in CoverStyleSwitcher.psm1 as you like.

If you enjoy the extension, you can buy me a coffee. It will be very appreciated ;)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/E1E214R1KB)


<table style="width: 100%; text-align: left;">
  <tr>
    <td style="padding: 0; vertical-align: top;">
      <img src="https://github.com/roob-p/CoverStyleSwitcher-PlayniteExtension/blob/main/media/1.gif" style="width: 100%; height: auto;" />
    </td>
  </tr>
  <tr>
    <td style="padding: 0; vertical-align: top;">
      <img src="https://github.com/roob-p/CoverStyleSwitcher-PlayniteExtension/blob/main/media/2.gif" style="width: 100%; height: auto;" />
    </td>
  </tr>
   <tr>
    <td style="padding: 0; vertical-align: top;">
      <img src="https://github.com/roob-p/CoverStyleSwitcher-PlayniteExtension/blob/main/media/3.gif" style="width: 100%; height: auto;" />
</table>
