# remove SFDX spinner
export FORCE_SPINNER_DELAY=
export FORCE_SHOW_SPINNER=

# create the commands-list.json file
sfdx force:doc:commands:list --json | jq -r .result > commands-list.json

completion=""
completion+="#compdef sfdx"

# header
completion+="\n"
completion+="\n# DESCRIPTION: ZSH completion script for the Salesforce CLI"
completion+="\n# AUTHOR: Wade Wegner (@WadeWegner)"
completion+="\n# REPO: https://github.com/wadewegner/salesforce-cli-zsh-completion"
completion+="\n# LICENSE: https://github.com/wadewegner/salesforce-cli-zsh-completion/blob/master/LICENSE"
completion+="\n"
completion+="\nlocal -a _1st_arguments"
completion+="\n"
completion+="\n_1st_arguments=("

commands=""

while read name description
do
  name="$(echo $name | sed -e 's/:/\\:/g')"
  commands="${commands}\n\t\"$name\":\"$description\""

done <<< "$(jq -r 'to_entries[] | "\(.value.name)\t\(.value.description)"' commands-list.json)"

completion+=$commands
completion+="\n)"
completion+="\n"
completion+="\n_arguments '*:: :->command'"
completion+="\n"
completion+="\nif (( CURRENT == 1 )); then"
completion+="\n  _describe -t commands \"sfdx command\" _1st_arguments"
completion+="\n  return"
completion+="\nfi"
completion+="\n"

echo $completion > _sfdx