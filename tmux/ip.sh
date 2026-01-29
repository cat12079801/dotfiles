# How do I get the interface name?
ipconfig getifaddr en0 2>/dev/null || echo "N/A"
