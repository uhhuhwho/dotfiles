cat /sys/devices/system/cpu/intel_pstate/no_turbo

# Disable
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

# Enable
# echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
