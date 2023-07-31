#!/usr/bin/env nu

def main [] {
  mut lastSearch = ""

  while true {
    let command = (bash -c "read -t 1 input; inputOrTimeout=${input:="Timeout"}; echo $inputOrTimeout" | from json)

    if $command == "Exit" {
      break
    }

    if $command == "Interrupt" {
      continue
    }

    if ($command | describe) starts-with "record" and  $command.Search? != null {
      $lastSearch = $command.Search
    }
    let searchString = $lastSearch

    mut entries = (getEntries)
    if ($searchString | str length ) > 0  {
      $entries = ($entries | filter {|entry| entryMatchesSearch $entry $searchString })
    }

    if $command == "Timeout" {
      print '"Clear"'
    }
    printEntries $entries
  }
}

def getEntries [] {
  let date = (date now)
  let currentTime = ($date | date format '%H:%M:%S')
  let currentDate = ($date | date format '%A, %d. %B %Y')

  let timeEntry = ($'
    Append:
      id: 0
      name: ($currentTime)
      description: Time
      icon:
        Name: accessories-clock
  ' | from yml)

  let dateEntry = ($'
    Append:
      id: 1
      name: ($currentDate)
      description: Date
      icon:
        Name: date
  ' | from yml)

  return [ $timeEntry, $dateEntry ]
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
