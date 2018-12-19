# How do I get the interface name?
if type ifdata >/dev/null 2>&1; then
  if ifdata -pa eth0 >/dev/null 2>&1; then
    ifdata -pa eth0
  elif ifdata -pa en0 >/dev/null 2>&1; then
    ifdata -pa en0
  fi
else
  echo "no ifdata cmd"
fi
