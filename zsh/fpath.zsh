#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

fpath=($ZSH/functions $fpath)

echo Loading completions..
for file in $ZSH/functions/*(:t)
do
  echo "  $file"
done
autoload -U $ZSH/functions/*(:t)
