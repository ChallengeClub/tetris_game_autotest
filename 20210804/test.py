import subprocess

# CPU名を取得する
cpuResult = subprocess.check_output('wmic CPU get Name', stdin=DEVNULL, stderr=DEVNULL, shell=True)
cpu = str(cpuResult)
print(cpu)
