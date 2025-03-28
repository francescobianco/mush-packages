main () {

  [ -f .env ] && source .env

  curl_user=${CURL_USER}

  if [ -z "$curl_user" ]; then
    echo "Missing token"
    exit 1
  fi

  user=$(git config --get remote.origin.url | cut -d: -f2 | cut -d/ -f4)

  cp README.md README.md.0
  echo "# ${user} (traffic)" > README.md
  echo "[![Traffic Update](https://github.com/javanile/github-traffic/actions/workflows/update.yml/badge.svg)](https://github.com/javanile/github-traffic/actions/workflows/update.yml)" >> README.md
  echo "![Last Update](https://img.shields.io/badge/Last%20Update-$(date -u +%Y--%m--%d%%20%H%%3A%M%%3A%S)%20UTC-blue)  " >> README.md
  echo "This project collects all data of incoming traffic to our organization  " >> README.md
  echo "" >> README.md
  ## Get the list of repositories
  echo "Fetch repositories list"
  rm -f repositories.0 > /dev/null 2>&1
  for page in {1..5}; do
    curl -s "https://api.github.com/users/${user}/repos?page=${page}&per_page=100" | grep '"full_name":' | cut -d'"' -f4 >> repositories.0
  done

  ## Repositories classifier
  echo "Scan for repositories traffic"
  if [ -s repositories.0 ]; then
    rm -f repositories.1 > /dev/null 2>&1
    while IFS="" read -r repository || [ -n "$repository" ]; do
      info=$(curl -s -u "$curl_user" "https://api.github.com/repos/${repository}")
      stars=$(echo "$info" | grep '"stargazers_count":' | sed 's/[^0-9]*//g' | head -n1)
      traffic=$(curl -s -u "$curl_user" "https://api.github.com/repos/${repository}/traffic/popular/referrers")
      uniques=$(echo '"uniques":0' "${traffic}" | grep '"uniques"' | sed 's/[^0-9]*//g' | paste -s -d+ - | bc)
      views=$(echo '"count":0' "${traffic}" | grep '"count"' | sed 's/[^0-9]*//g' | paste -s -d+ - | bc)
      sources=$(echo "$traffic" | grep '"count"' | wc -l | xargs)
      echo "$repository $uniques $views $sources $stars" >> repositories.1
    done < repositories.0
  fi

  echo "Sort traffic data"
  if [ -s repositories.1 ]; then
    sort -t' ' -k2nr -k3nr -k4nr -k5nr -k1 repositories.1 > repositories.2
  fi

  if [ -s repositories.2 ]; then
    echo "Generating README.md file"
    echo '| Rank | Repository | Uniques | Views | Sources | Stars | Trend |' >> README.md
    echo '|:----:|------------|:-----:|:-------:|:-------:|:-----:|:-----:|' >> README.md
    rank=1
    while IFS="" read -r entry || [ -n "$entry" ]; do
      repository=$(echo "$entry" | cut -d' ' -f1)
      uniques=$(echo "$entry" | cut -d' ' -f2)
      views=$(echo "$entry" | cut -d' ' -f3)
      sources=$(echo "$entry" | cut -d' ' -f4)
      stars=$(echo "$entry" | cut -d' ' -f5)
      last_rank=$(grep "\[$repository\]" README.md.0 | head -1 | cut -d'|' -f2 | xargs)
      [ "$rank" -gt "$last_rank" ] && trend="🟥" || trend=""
      [ "$rank" -lt "$last_rank" ] && trend="🟩"
      echo "| $rank | [$repository](https://github.com/$repository) | $uniques | $views | $sources | $stars | $trend |" >> README.md
      rank=$((rank+1))
    done < repositories.2
  fi

  echo "" >> README.md
  echo "## License" >> README.md
  echo "The MIT License (MIT). Please see [License File](LICENSE) for more information." >> README.md
}
