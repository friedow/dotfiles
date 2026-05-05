#!/usr/bin/env nu

def fetch-repos [] {
  let gh_repos = try {
    ^gh repo list --limit 1000 --json nameWithOwner
    | from json
    | get nameWithOwner
    | each { |r| $"github/($r)" }
  } catch {
    []
  }

  let gl_repos = try {
    ^glab repo list --output json
    | from json
    | get path_with_namespace
    | each { |r| $"gitlab/($r)" }
  } catch {
    []
  }

  [...$gh_repos, ...$gl_repos]
}

def fetch-items [provider: string, repo: string, type: string] {
  if $type == "issue" {
    if $provider == "github" {
      ^gh issue list --repo $repo --json number,title --limit 100
      | from json
      | each { |i| $"#($i.number) ($i.title)" }
    } else {
      ^glab issue list --repo $repo --output json
      | from json
      | each { |i| $"#($i.iid) ($i.title)" }
    }
  } else {
    if $provider == "github" {
      ^gh pr list --repo $repo --json number,title --limit 100
      | from json
      | each { |i| $"#($i.number) ($i.title)" }
    } else {
      ^glab mr list --repo $repo --output json
      | from json
      | each { |i| $"#($i.iid) ($i.title)" }
    }
  }
}

def get-clone-url [provider: string, repo: string] {
  if $provider == "github" {
    ^gh repo view $repo --json sshUrl | from json | get sshUrl
  } else {
    ^glab repo view $repo --output json | from json | get ssh_url_to_repo
  }
}

def main [type: string] {
  # Select repository from GitHub and GitLab combined
  let repos = (fetch-repos)
  let selected_repo = ($repos | input list --fuzzy "Repository: ")

  # Parse provider and repo path (e.g. "github/org/repo" or "gitlab/group/project")
  let parts = ($selected_repo | split row "/")
  let provider = ($parts | first)
  let repo = ($parts | skip 1 | str join "/")

  # Parse org and repo name for directory structure
  let repo_parts = ($repo | split row "/")
  let org = ($repo_parts | first)
  let repo_name = ($repo_parts | last)

  # Select issue or PR
  let items = (fetch-items $provider $repo $type)
  let selected_item = ($items | input list --fuzzy $"($type): ")

  # Parse the issue/PR number from "#<N> <title>"
  let number = ($selected_item | parse "#{number} {title}" | get number | first)

  # Clone into structured directory
  let clone_dir = ($env.HOME | path join "code" $provider $org $repo_name $"ticket-($number)")
  let clone_url = (get-clone-url $provider $repo)

  ^git clone --depth 25 --single-branch --branch main $clone_url $clone_dir

  # Create ticket branch
  ^git -C $clone_dir checkout -b $"cf/ticket-($number)"

  # Focus a new niri workspace and name it
  ^niri msg action focus-workspace-down
  ^niri msg action set-workspace-name $"ticket-($number)"

  # Launch brave with the ticket name as the window class (app-id on Wayland)
  ^sh -c $"brave --new-window --window-name='brave | ticket-#($number)' &"

  # Create tmux session with project windows
  let session = $"ticket-($number)"

  let issue_cmd = if $type == "issue" {
    if $provider == "github" {
      $"gh issue view ($number) --repo ($repo)"
    } else {
      $"glab issue view ($number) --repo ($repo)"
    }
  } else {
    if $provider == "github" {
      $"gh pr view ($number) --repo ($repo)"
    } else {
      $"glab mr view ($number) --repo ($repo)"
    }
  }

  ^tmux new-session -s $session -d -c $clone_dir
  ^tmux rename-window -t $"($session):1" "shell"
  ^tmux new-window -t $session -n "nvim" -c $clone_dir "nvim ."
  ^tmux new-window -t $session -n "issue" -c $clone_dir $issue_cmd
  ^tmux new-window -t $session -n "claude" -c $clone_dir "claude"
  ^tmux select-window -t $"($session):shell"

  # Launch kitty attached to the tmux session
  ^sh -c $"kitty --title 'kitty | ticket-#($number)' --execute tmux attach-session -t ($session) &"
}
