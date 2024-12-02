
$global:coverPath= "c:\Cover Styles\"



 $global:currentLanguage=(Get-Culture).Name
 
 $global:messages = @{
	"en" = @{
        	"noSavedCover"  = "No saved cover found for: "
		"noSavedCovers" = "No saved covers found for: "
		"SaveOriginal"	= "Do you want to save the selected cover?"
		"SaveOriginals" = "Do you want to save the selected covers?"
		"Warning2A"	= "Warning: You have chosen"
		"Warning2B"	= "covers while there are"
		"Warning2C"	= "selected games. Do you want to continue?"
		"Warning1A"	= "Warning: You have chosen only one cover while there are"
		"Warning1B"	= "selected games. Do you want to continue?"

    }
    "it" = @{
		"noSavedCover"  = "Non risultano cover salvate di: "
       	        "noSavedCovers" = "Non risultano cover salvate di: "
		"SaveOriginal"  = "Vuoi salvare la cover selezionate?"
		"SaveOriginals" = "Vuoi salvare le cover selezionate?"
		"Warning2A"	= "Attenzione: Hai selezionato"
		"Warning2B"	= "cover ma ci sono"
		"Warning2C"	= "giochi selezionati. Vuoi continuare?"
		"Warning1A" 	= "Attenzione: Hai selezionato solo una cover, ma ci sono"
		"Warning1B"	= "giochi selezionati. Vuoi continuare?"

    }
	"fr" = @{
        	"noSavedCover"  = "Aucune couverture enregistrée pour: "
		"noSavedCovers" = "Aucune couverture enregistrée pour: "
		"SaveOriginal"  = "Voulez-vous sauvegarder les couverture sélectionnées ?"
		"SaveOriginals" = "Voulez-vous sauvegarder les couvertures sélectionnées ?"
		"Warning2A"	= "Attention : vous avez sélectionné"
		"Warning2B"	= "couvertures, mais il y a"
		"Warning2C"	= "jeux sélectionnés. Voulez-vous continuer ?"
		"Warning1A" 	= "Attention : vous avez sélectionné une seule couverture, mais il y a"
		"Warning1B" 	= "jeux sélectionnés. Voulez-vous continuer?"

    }
	"es" = @{
		"noSavedCover"  = "No se ha encontrado portada guardada para: "
		"noSavedCovers" = "No se han encontrado portadas guardadas para: "
		"SaveOriginal"  = "¿Deseas guardar la portada seleccionada?"
        	"SaveOriginals" = "¿Deseas guardar las portadas seleccionadas?"
		"Warning2A"	= "Advertencia: has seleccionado"
		"Warning2B"	= "portadas, pero hay"
		"Warning2C"	= "juegos seleccionados. ¿Quieres continuar?"
		"Warning1A" 	= "Advertencia: has seleccionado solo una portada, pero hay"
		"Warning1B" 	= "juegos seleccionados. ¿Quieres continuar?"

		
	}
	"de" = @{
        	"noSavedCover"  = "Keine gespeicherte Cover gefunden für: "
       		"noSavedCovers" = "Keine gespeicherten Cover gefunden für: "
        	"SaveOriginal"  = "Möchten Sie das ausgewählte Cover speichern?"
        	"SaveOriginals" = "Möchten Sie die ausgewählten Cover speichern?"
		"Warning2A"	= "Achtung: Sie haben"
		"Warning2B"	= "Cover ausgewählt, aber es sind nur"
		"Warning2C"	= "Spiele ausgewählt. Möchten Sie fortfahren?"
		"Warning1A"     = "Achtung: Sie haben nur ein Cover ausgewählt, aber es sind"
		"Warning1B"	= "Spiele ausgewählt. Möchten Sie fortfahren?"

    }
 }
 
 #$global:currentLanguage= "it"
 
 if ($global:messages.ContainsKey($global:currentLanguage)){
	
	 }else{$global:currentLanguage= "en" }

 
  
  


function backup_slot()
{
	param(
		$getGameMenuItemsArgs
	)
$coverPath=$global:coverPath	
$currentLanguage=$global:currentLanguage
$messages=$global:messages

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
$coverPath=$global:coverPath
$currentLanguage=$global:currentLanguage
$messages=$global:messages

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
	

$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$file$ext", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)


   
   
   
}elseif (Test-Path $file)  {

$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$file", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)
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




$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileI$extI", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)
}elseif (Test-Path $fileI)  {	
$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileI", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)

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





$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileS$extS", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)
}elseif (Test-Path $fileS)  {
$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileS", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)	
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
	 


	

$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileSI$extSI", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)

	$ou="$($game.id)$extSI"

 }elseif (Test-Path $fileSI)  {


$PlayniteApi.Database.RemoveFile($gamed.coverImage)
$gamed.CoverImage = $PlayniteApi.Database.AddFile("$fileSI", $gamed.Id)
$PlayniteApi.Database.Games.Update($gamed)
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
	
$currentLanguage=$global:currentLanguage
$messages=$global:messages

$Gamesel = $PlayniteApi.MainView.SelectedGames
$orderedGames = $Gamesel | Sort-Object -Property Name

#foreach ($Game in $Gamesel) { 
foreach ($Game in $orderedGames) { 

$u=$null
$cc=$null

$gamed = $PlayniteApi.Database.Games[$game.id]
#$u=$PlayniteApi.Dialogs.SelectImageFile()
$u=$PlayniteApi.Dialogs.SelectFiles("Image files (jpg, png, bmp, webp|*.jpg;*.png;*.bmp;*.webp;*)")





if (!([string]::IsNullOrWhiteSpace($u))) { $cc = $PlayniteApi.Database.AddFile($u, $gamed.Id)}
if ($cc -ne $null) {
	
	$PlayniteApi.Database.RemoveFile($gamed.coverImage)
	$gamed.CoverImage = $cc                            
	$PlayniteApi.Database.Games.Update($gamed)   

	}

}


} #endfunc






function coverchange2()
{
	param(
		$getGameMenuItemsArgs
	)
	
$currentLanguage=$global:currentLanguage
$messages=$global:messages

$Gamesel = $PlayniteApi.MainView.SelectedGames
$orderedGames = $Gamesel | Sort-Object -Property Name

$warn=""
$wargo="true"

#$u=$PlayniteApi.Dialogs.SelectFiles("Image files (*.jpg, *.png, *.bmp|*.jpg;*.png;*.bmp")
$u=$PlayniteApi.Dialogs.SelectFiles("Image files (jpg, png, bmp, webp|*.jpg;*.png;*.bmp;*.webp;*)")



if (($u.count -lt $Gamesel.count) -and ($u.count -eq 1)){$warn = $PlayniteApi.Dialogs.ShowMessage("$($messages[$currentLanguage]['Warning1A']) $($Gamesel.Count) $($messages[$currentLanguage]['Warning1B'])", "MyMessage",[System.Windows.MessageBoxButton]::YesNo)}
if (($u.count -ne $Gamesel.count) -and ($u.count -gt 1)) {$warn = $PlayniteApi.Dialogs.ShowMessage("$($messages[$currentLanguage]['Warning2A']) $($u.Count) $($messages[$currentLanguage]['Warning2B']) $($Gamesel.Count) $($messages[$currentLanguage]['Warning2C'])", "MyMessage",[System.Windows.MessageBoxButton]::YesNo)}
if ($warn -eq "Yes"){ $wargo="true"}elseif($warn -eq "No"){$wargo="false"}





if ($wargo -eq "true"){

#>

$i=0
#foreach ($Game in $Gamesel) { 
foreach ($Game in $orderedGames) { 

#$u=$null
#$cc=$null

$gamed = $PlayniteApi.Database.Games[$game.id]


if (!([string]::IsNullOrWhiteSpace($u)) -and ($i -lt $u.count)) { $cc = $PlayniteApi.Database.AddFile($u[$i], $gamed.Id)#}
if ($cc -ne $null) {
	
	$PlayniteApi.Database.RemoveFile($gamed.coverImage)
	$gamed.CoverImage = $cc                            
	$PlayniteApi.Database.Games.Update($gamed)   

	}
$i+=1

}#endif
}#foreach

}#wargo

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


 $currentLang=(Get-Culture).Name
 
 $global:itemstrings = @{
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
 
  #$currentLang="it"
 
  if (!$itemstrings.ContainsKey($currentLang)) {
	 $currentLang="en" 
  }


$save=$itemstrings[$currentLang]["Save"]
$load=$itemstrings[$currentLang]["Load"]
$original=$itemstrings[$currentLang]["Original"]
$originals=$itemstrings[$currentLang]["Originals"]
$changemanually=$itemstrings[$currentLang]["Change manually"]
$changemanually2=$itemstrings[$currentLang]["Change manually2"]
 

	
	
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
	
	
	$menuItemD = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemD.Description = $changemanually2
    $menuItemD.FunctionName = "coverchange2"
	$menuItemD.MenuSection = "Cover Style Switcher"
	$menuItemD.Icon = "$PSScriptRoot"+"\icon1.png"
	#>
	
	


    
    return $menuItemB0,$menuItemB1,$menuItemB2,$menuItemB3,$menuItemB4,$menuItemB5,$menuItemL0,$menuItemL1,$menuItemL2,$menuItemL3,$menuItemL4,$menuItemL5,$menuItemC,$menuItemD




}


