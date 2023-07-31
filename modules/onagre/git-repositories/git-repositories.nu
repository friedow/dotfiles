#!/usr/bin/env nu

def main [] {
  mut $entries = []

  while true {
    let command = (bash -c "read line; echo $line" | from json)

    if $command == "Exit" {
      break
    }

    if $command == "Interrupt" {
      continue
    }

    if not ($command | describe) starts-with "record" {
      exit 1;
    }

    if $command.Activate? != null {
      activateEntry ($entries | get $command.Activate)
      break
    }

    if $command.Search? != null {
      $entries = (getEntries)
      printEntries ($entries | filter {|entry| entryMatchesSearch $entry $command.Search })
    }
  }
}

def folderColor [entryIndex: int] {
  let folderColors = [
    "green",
    "indigo",
    "pink",
    "teal",
    "yellow",
    "cyan",
    "magenta",
    "orange",
    "red",
    "violet"
  ]
  let colorIndex = ($entryIndex mod ($folderColors | length))

  return ($folderColors | get $colorIndex)
}

def getEntries [] {
  let gitRepositoryPaths = (open "~/.cache/pop-launcher/git-repositories.txt" | lines | enumerate)

  return ($gitRepositoryPaths | each { |gitRepositoryPath|
    let gitRepositoryName = ($gitRepositoryPath.item | str replace ".*/([^/]+)" "$1")
    $'
      Append:
        id: ($gitRepositoryPath.index)
        name: ($gitRepositoryName)
        description: ($gitRepositoryPath.item)
        icon:
          Name: folder-(folderColor $gitRepositoryPath.index)-git
    ' | from yml
  })
}

def spawn [command: string] {
  bash -c $"($command) &"
}

def activateEntry [entry: record] {
  spawn $'alacritty --working-directory "($entry.Append.description)"'
  spawn $'sublime -n "($entry.Append.description)"'
  spawn $'sublime_merge -n "($entry.Append.description)"'
  print '"Close"'
}

def entryMatchesSearch [entry: record, searchString: string] {
  let searchTerms = ($searchString | str downcase | split words)

  let entryString = ($entry.Append.name + " " + $entry.Append.description)
  let entryTerms = ($entryString | str downcase | split words)

  for searchTerm in $searchTerms {
    for entryTerm in $entryTerms {
      if ($entryTerm | str distance $searchTerm | $in <= 2) {
        return true
      }

      if ($entryTerm | str contains $searchTerm) {
        return true
      }
    }
  }

  return false
}

def printEntries [entries: list] {
  for entry in $entries {
    print ($entry | to json -r)
  }
  print '"Finished"'
}
