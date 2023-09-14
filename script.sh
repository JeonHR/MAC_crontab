
LP=/Users/cm/Documents
HR=/Users/Shared/atelogs
HR2=/Users/Shared/atelogs/read_logs
RH=/Users/Shared/local-cm/initchip/r2b0
PL=/Users/eagle/Documents


echo "cmcm" | sudo -S chmod -R 777 "$PL"

find ${LP} -name "lp-*" -type d -mtime +7 -exec rm -rf {} \;      
find ${HR} -name "r2_ate_logfile_*" -mtime +7 -exec rm -rf {} \;
find ${HR2} -name "r2_ate_logfile_*" -mtime +7 -exec rm -rf {} \;
find ${RH} -name "*" -mtime +7 -exec rm -rf {} \;
find ${PL} -name "rmod_install-*" -type d -mtime +7 -exec rm -rf {} \;   