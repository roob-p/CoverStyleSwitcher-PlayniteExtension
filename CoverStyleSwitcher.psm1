
$coverPath= "c:\Cover Styles\"



 $currentLanguage=(Get-Culture).Name
 
 $messages = @{
	"en" = @{
        "noSavedCover"  = "No saved cover found for: "
		"noSavedCovers" = "No saved covers found for: "
		"SaveOriginal"	= "Do you want to save the selected cover?"
		"SaveOriginals" = "Do you want to save the selected covers?"
    }
    "it" = @{
		"noSavedCover"  = "Non risultano cover salvate di: "
        "noSavedCovers" = "Non risultano cover salvate di: "
		"SaveOriginal"  = "Vuoi salvare la cover selezionate?"
		"SaveOriginals" = "Vuoi salvare le cover selezionate?"
    }
	"fr" = @{
        "noSavedCover"  = "Aucune couverture enregistrée pour: "
		"noSavedCovers" = "Aucune couverture enregistrée pour: "
		"SaveOriginal"  = "Voulez-vous sauvegarder les couverture sélectionnées ?"
		"SaveOriginals" = "Voulez-vous sauvegarder les couvertures sélectionnées ?"
    }
	"es" = @{
		"noSavedCover"  = "No se ha encontrado portada guardada para: "
		"noSavedCovers" = "No se han encontrado portadas guardadas para: "
		"SaveOriginal"  = "¿Deseas guardar la portada seleccionada?"
        "SaveOriginals" = "¿Deseas guardar las portadas seleccionadas?"
	}
	"de" = @{
        "noSavedCover"  = "Keine gespeicherte Cover gefunden für: "
        "noSavedCovers" = "Keine gespeicherten Cover gefunden für: "
        "SaveOriginal"  = "Möchten Sie das ausgewählte Cover speichern?"
        "SaveOriginals" = "Möchten Sie die ausgewählten Cover speichern?"
    }
 }
 
 #$currentLanguage= "it"
 
  if (!$messages.ContainsKey($currentLanguage)) {
	 $currentLanguage= "en" 
  }
  
  
  


function backup_slot()
{
	param(
		$getGameMenuItemsArgs
	)



$go="true"
$Gameselcount = $PlayniteApi.MainView.SelectedGames
if ($slot -eq "Original"){
#$selection = $PlayniteApi.Dialogs.ShowMessage("Do you want to save the selected covers?", "MyMessage", [System.Windows.MessageBoxButton]::YesNo)
if($Gameselcount.count -gt 1){
$selection = $PlayniteApi.Dialogs.ShowMessage($messages[$currentLanguage]["SaveOriginals"], "MyMessage", [System.Windows.MessageBoxButton]::YesNo)
} else {$selection = $PlayniteApi.Dialogs.ShowMessage($messages[$currentLanguage]["SaveOriginal"], "MyMessage", [System.Windows.MessageBoxButton]::YesNo)}
if ($selection -eq "Yes"){
	$go="true"
}
else {$go="false"}
}

if ($go -eq "true"){

$Gamesel = $PlayniteApi.MainView.SelectedGames
foreach ($Game in $Gamesel) { 

$u=$null
$cc=$null

#$coverPath= "c:\aaprove\"



$gamed = $PlayniteApi.Database.Games[$game.id]

$plat=$game.platforms.name
$source=$game.source.name

#backup gameid
if($game.coverImage){
$coverex=$PlayniteApi.Database.GetFullFilePath($game.coverImage)
$estensione = [System.IO.Path]::GetExtension($coverex)

if(!$game.source.name){

New-Item -Path "$coverPath" -Name "Backup\$slot\gameid\$plat\" -ItemType "directory" -force
Copy-item $coverex "$coverPath\Backup\$slot\gameid\$plat\$($game.id)$estensione" -force

if ($gamed -notmatch '[\/\:\*?"<>|]'){

#backup nomegioco
New-Item -Path "$coverPath" -Name "Backup\$slot\$plat\" -ItemType "directory" -force
Copy-Item $coverex "$coverPath\Backup\$slot\$plat\$game$estensione" -Force
}
else {
	$oo="$game$estensione"
	$oo = $oo -replace '[\/\:\*?"<>|]'
	#$PlayniteApi.Dialogs.ShowMessage($oo)
	New-Item -Path "$coverPath" -Name "Backup\$slot\special characters\$plat\" -ItemType "directory" -force
	Copy-Item $coverex "$coverPath\Backup\$slot\special characters\$plat\$oo" -Force
}
}#endif source
else{  #C'è il source
	
New-Item -Path "$coverPath" -Name "Backup\$slot\gameid\$source\" -ItemType "directory" -force
Copy-item $coverex "$coverPath\Backup\$slot\gameid\$source\$($game.id)$estensione" -force

if ($gamed -notmatch '[\/\:\*?"<>|]'){

#backup nomegioco
New-Item -Path "$coverPath" -Name "Backup\$slot\$source\" -ItemType "directory" -force
Copy-Item $coverex "$coverPath\Backup\$slot\$source\$game$estensione" -Force
}
else {
	$oo="$game$estensione"
	$oo = $oo -replace '[\/\:\*?"<>|]'
	#$PlayniteApi.Dialogs.ShowMessage($oo)
	New-Item -Path "$coverPath" -Name "Backup\$slot\special characters\$source\" -ItemType "directory" -force
	Copy-Item $coverex "$coverPath\Backup\$slot\special characters\$source\$oo" -Force
}	
	
	
}








}#endif cover image

	} #foreach
}#endif go=true
##}# end prompt
##}#endif check $slot="Original"
} #endfunc




function load_slot()
{
	param(
		$getGameMenuItemsArgs
	)


$nocovergames=@()	
	
$Gamesel = $PlayniteApi.MainView.SelectedGames
foreach ($Game in $Gamesel) { 

$gamed = $PlayniteApi.Database.Games[$game.id]


$coverex=$PlayniteApi.Database.GetFullFilePath($game.coverImage)
$estensione = [System.IO.Path]::GetExtension($coverex)




if(!$game.source.name){
	
$plat=$game.platforms.name
$source=$game.source.name
$file="$coverPath\Backup\$slot\$plat\$game"
$fileT="$coverPath\Backup\$slot\$plat\$game.*"
	
	

if ($gamed -notmatch '[\/\:\*?"<>|]'){


 if (Test-Path $fileT) {
	 $ext = (Get-Item $fileT).Extension
	 $ext = $ext.Trim().Split(' ')[0]
	


$game.CoverImage = $PlayniteApi.Database.AddFile("$file$ext", $game.Id)
$PlayniteApi.Database.Games.Update($game)

   
   
   
}elseif (Test-Path $file)  {
$game.CoverImage = $PlayniteApi.Database.AddFile("$file", $game.Id)
$PlayniteApi.Database.Games.Update($game)
} else {  #Non trova cover salvate
	#$nocovergames+=$game.name + ", "
	$nocovergames+=$game.name

	
}
 

}#endif Il nome non ha caratteri strani
else { #Game with special characters

$plat=$game.platforms.name
$source=$game.source.name	
$fileI="$coverPath\Backup\$slot\gameid\$plat\$($game.id)"
$fileIT="$coverPath\Backup\$slot\gameid\$plat\$($game.id).*"


	
 if (Test-Path $fileIT) {
	 $extI = (Get-Item $fileIT).Extension
	 $extI = $extI.Trim().Split(' ')[0]



$game.CoverImage = $PlayniteApi.Database.AddFile("$fileI$extI", $game.Id)
$PlayniteApi.Database.Games.Update($game)
	
}elseif (Test-Path $fileI)  {	
$game.CoverImage = $PlayniteApi.Database.AddFile("$fileI", $game.Id)
$PlayniteApi.Database.Games.Update($game)
} else {  #Non trova cover salvate
	
	$nocovergames+=$game.name
}

}#end game with special characters

}#endif no source
else {   #Source
	
$plat=$game.platforms.name
$source=$game.source.name
$fileS="$coverPath\Backup\$slot\$source\$game"
$fileST="$coverPath\Backup\$slot\$source\$game.*"
	
	if ($gamed -notmatch '[\/\:\*?"<>|]'){


 if (Test-Path $fileST) {
	
	 $extS = (Get-Item $fileST).Extension
	 $extS = $extS.Trim().Split(' ')[0]




$game.CoverImage = $PlayniteApi.Database.AddFile("$fileS$extS", $game.Id)
$PlayniteApi.Database.Games.Update($game)

}elseif (Test-Path $fileS)  {
$game.CoverImage = $PlayniteApi.Database.AddFile("$fileS", $game.Id)
$PlayniteApi.Database.Games.Update($game)	
} else {
	#$nocovergames+=$game.name + ", "
	$nocovergames+=$game.name

	
}
 

}#endif Game without special characters
else { #Game with special characters
	
$fileSI="$coverPath\Backup\$slot\gameid\$source\$($game.id)"
$fileSIT="$coverPath\Backup\$slot\gameid\$source\$($game.id).*"


	
 if (Test-Path $fileSIT) {
	
	 $extSI = (Get-Item $fileSIT).Extension
	 $extSI = $extSI.Trim().Split(' ')[0]
	 


	
$game.CoverImage = $PlayniteApi.Database.AddFile("$fileSI$extSI", $game.Id)
$PlayniteApi.Database.Games.Update($game)

	$ou="$($game.id)$extSI"

 }elseif (Test-Path $fileSI)  {
$game.CoverImage = $PlayniteApi.Database.AddFile("$fileSI", $game.Id)
$PlayniteApi.Database.Games.Update($game)
 }else{
		
	#Non trova cover salvate
	#$nocovergames+=$game.name + ", "
	$nocovergames+=$game.name
	}
}#endif Game with special characyers



} #endif Si source


} #foreach
  
  if ($nocovergames -ne $null){
	
	 $nocovergamesU= $nocovergames -join ", "
	 $nocovergames = $nocovergamesU#.TrimEnd(", ")
  ##$PlayniteApi.Dialogs.ShowMessage("Non risultano cover salvate di: "+$nocovergames)
  if($PlayniteApi.MainView.SelectedGames.count -gt 1){
$PlayniteApi.Dialogs.ShowMessage($messages[$currentLanguage]["noSavedCovers"] +$nocovergames)
} else {$PlayniteApi.Dialogs.ShowMessage($messages[$currentLanguage]["noSavedCover"] +$nocovergames)
  }
  
  
  }
 
	
} #endfunc



function coverchange()
{
	param(
		$getGameMenuItemsArgs
	)
	
$Gamesel = $PlayniteApi.MainView.SelectedGames
#$orderedGames = $Gamesel | Sort-Object -Property Name

foreach ($Game in $Gamesel) { 

$u=$null
$cc=$null

$gamed = $PlayniteApi.Database.Games[$game.id]
$u=$PlayniteApi.Dialogs.SelectImageFile()





if (!([string]::IsNullOrWhiteSpace($u))) { $cc = $PlayniteApi.Database.AddFile($u, $game.Id)}
if ($cc -ne $null) {
	
	$PlayniteApi.Database.RemoveFile($gamed.id)
	$gamed.CoverImage = $cc
	$PlayniteApi.Database.Games.Update($gamed)
	$PlayniteApi.Database.Games.Update($gamed)

	}

}


} #endfunc










function backup_slot0() {
	param(
		$getGameMenuItemsArgs
	)
	
    $slot = "Original"
	backup_slot
}


function backup_slot1(){
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot1"
    backup_slot
}
function backup_slot2() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot2"
	backup_slot
}
function backup_slot3() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot3"
	backup_slot
}
function backup_slot4() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot4"
	backup_slot
}
function backup_slot5() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot5"
	backup_slot
}


function load_slot0() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "Original"
	load_slot
}

function load_slot1(){
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot1"
    load_slot
}
function load_slot2() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot2"
	load_slot
}
function load_slot3() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot3"
	load_slot
}
function load_slot4() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot4"
	load_slot
}
function load_slot5() {
	param(
		$getGameMenuItemsArgs
	)
    $slot = "slot5"
	load_slot
}



function getGameMenuItems{
	
	param(
		$getGameMenuItemsArgs
	)


 $currentLanguage=(Get-Culture).Name
 
 $itemstrings = @{
	"en" = @{
		"Change manually"  = "Change with Explorer"
		"Load" 			   = "Load" 
		"Save" 			   = "Save" 
		"Original"		   = "Originale"
		"Originals"		   = "Originali"
		"Change manually2" = "Change with Explorer (batch)"
    }
    "it" = @{
		"Change manually"  = "Cambia con Explorer"
		"Load" 			   = "Carica" 
		"Save" 			   = "Salva" 
		"Original"		   = "Original"
		"Originals"        = "Originals" 
		"Change manually2" = "Cambia con Explorer (batch)"
    }
	"fr" = @{
		"Change manually"  = "Changer avec l'Explorateur"
		"Load"             = "Charger"
      	"Save" 		       = "Sauvegarder"
		"Original"         = "Original"
		"Originals"        = "Originaux" 
		"Change manually2" = "Changer avec l'Explorateur (par lot)"
    }
	"es" = @{
		"Change manually"  = "Cambiar con Explorador"
		"Load"             = "Cargar"
        "Save"             = "Guardar"        
		"Original"         = "Original"  
		"Originals"        = "Originales" 
		"Change manually2" = "Cambiar con el Explorador (por lotes)"
	}
	 "de" = @{
		"Change manually"  = "Mit dem Explorer" 
        "Load"             = "Laden"
        "Save"    	       = "Speichern"
        "Original"         = "Original"
		"Originals"        = "Originale" 	
		"Change manually2" = "Mit dem Explorer ändern (Stapel)"		
    }
 }
 
  if (!$itemstrings.ContainsKey($currentLanguage)) {
	 $currentLanguage="en" 
  }
 #$currentLanguage="it"

$save=$itemstrings[$currentLanguage]["Save"]
$load=$itemstrings[$currentLanguage]["Load"]
$original=$itemstrings[$currentLanguage]["Original"]
$originals=$itemstrings[$currentLanguage]["Originals"]
$changemanually=$itemstrings[$currentLanguage]["Change manually"]
#$changemanually2=$changemanually=$itemstrings[$currentLanguage]["Change manually2"]
 

	
	
    $menuItemB0 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB0.Description = "Original"
    $menuItemB0.FunctionName = "backup_slot0"
	$menuItemB0.Icon = "$PSScriptRoot"+"\icon1.png"
	$menuItemB0.MenuSection = "Cover Style Switcher|$save"

	
	
	$menuItemB1 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB1.Description = "slot1"
    $menuItemB1.FunctionName = "backup_slot1"
	$menuItemB1.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemB1.MenuSection = "Cover Style Switcher|$save"
	#$menuItemB1.Tag = "slot1"
	
	$menuItemB2 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB2.Description = "slot2"
    $menuItemB2.FunctionName = "backup_slot2"
	$menuItemB2.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemB2.MenuSection = "Cover Style Switcher|$save"
	
	$menuItemB3 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB3.Description = "slot3"
    $menuItemB3.FunctionName = "backup_slot3"
	$menuItemB3.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemB3.MenuSection = "Cover Style Switcher|$save"
	
	$menuItemB4 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB4.Description = "slot4"
    $menuItemB4.FunctionName = "backup_slot4"
	$menuItemB4.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemB4.MenuSection = "Cover Style Switcher|$save"
	
	$menuItemB5 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemB5.Description = "slot5"
    $menuItemB5.FunctionName = "backup_slot5"
	$menuItemB5.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemB5.MenuSection = "Cover Style Switcher|$save"
	
	$menuItemL0 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL0.Description = "Original"
    $menuItemL0.FunctionName = "load_slot0"
	$menuItemL0.Icon = "$PSScriptRoot"+"\icon1.png"
	$menuItemL0.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemL1 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL1.Description = "slot1"
    $menuItemL1.FunctionName = "load_slot1"
	$menuItemL1.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemL1.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemL2 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL2.Description = "slot2"
    $menuItemL2.FunctionName = "load_slot2"
	$menuItemL2.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemL2.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemL3 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL3.Description = "slot3"
    $menuItemL3.FunctionName = "load_slot3"
	$menuItemL3.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemL3.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemL4 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL4.Description = "slot4"
    $menuItemL4.FunctionName = "load_slot4"
	$menuItemL4.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemL4.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemL5 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemL5.Description = "slot5"
    $menuItemL5.FunctionName = "load_slot5"
	$menuItemL5.Icon = "$PSScriptRoot"+"\icon2.png"
	$menuItemL5.MenuSection = "Cover Style Switcher|$Load"
	
	$menuItemC = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemC.Description = $changemanually
    $menuItemC.FunctionName = "coverchange"
	$menuItemC.MenuSection = "Cover Style Switcher"
	$menuItemC.Icon = "$PSScriptRoot"+"\icon1.png"
	
	#$menuItemD = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	#$menuItemD.Description = $changemanually2
    #$menuItemD.FunctionName = "coverchange2"
	#$menuItemD.MenuSection = "Cover Style Switcher"
	#$menuItemD.Icon = "$PSScriptRoot"+"\icon1.png"
	
	


    
    return $menuItemB0,$menuItemB1,$menuItemB2,$menuItemB3,$menuItemB4,$menuItemB5,$menuItemL0,$menuItemL1,$menuItemL2,$menuItemL3,$menuItemL4,$menuItemL5,$menuItemC #,$menuItemD




}


