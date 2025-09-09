# Gitlab cli

glfi() {
  # Find issue
  glab issue list --output json | jq -r '.[] | "\(.iid) \(.title)"' | fzf --prompt='Select an issue: ' --height=20% --layout=reverse
}

glin() {
  # Find issue and copy number to clipboard
  selected_issue=$(glfi)
  issue_number=$(echo "$selected_issue" | awk '{print $1}')

  # Check if an issue was selected and copy to clipboard
  if [ -n "$issue_number" ]; then
    echo "$issue_number" | pbcopy
    echo "Issue number $issue_number has been copied to the clipboard."
  else
    echo "No issue selected."
  fi
}

glcmr() {
  # Create merge request from found issue
  # Fetch issues and select one using fzf
  selected_issue=$(glfi)

  # Extract the issue number and title from the selected line
  issue_number=$(echo "$selected_issue" | awk '{print $1}')
  issue_title=$(echo "$selected_issue" | cut -d' ' -f2-)
  issue_title_parameterized=$(echo "$issue_title" | tr '[:space:]' '-' | tr -cd '[:alnum:]-')

  # Convert branch name to lowercase
  branch_name=$(echo "${issue_number}-${issue_title_parameterized}" | tr '[:upper:]' '[:lower:]')

  # Exit if no issue was selected
  if [ -z "$issue_number" ]; then
    echo "No issue selected."
    exit 1
  fi

  # Read the MR template from a file
  description_content=$(cat ~/dotfiles/shell/.zsh/default_mr_template.md)

  # Create a new branch with the formatted title
  git checkout -b "$branch_name"

  # Assuming the merge request is to be made from this new branch
  glab mr create --draft --title "$issue_title" --description "$description_content\n\nRelated issue: #$issue_number" --assignee @me
}
