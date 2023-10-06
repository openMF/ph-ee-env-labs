slave_array=(172.31.26.214); index=1 && while [ ${index} -gt 0 ]; do for slave in ${slave_array[@]}; do if echo 'test open port' 2>/dev/null > /dev/tcp/${slave}/1099; then echo ${slave}' ready' && slave_array=(${slave_array[@]/${slave}/}); index=$((index-1)); else echo ${slave}' not ready'; fi; done; echo 'Waiting for slave readiness'; sleep 2; done
echo "Installing needed plugins for master"
cd /opt/jmeter/apache-jmeter/bin
sh PluginsManagerCMD.sh install-for-jmx GSMA-inbound-transaction.jmx
echo "Done installing plugins, launching test"
jmeter -Ghost= -Gport= -Gprotocol= -Gthreads= -Gduration= -Grampup= --reportatendofloadtests --reportoutputfolder /report/report-GSMA-inbound-transaction.jmx-2023-10-06_164316 --logfile /report/GSMA-inbound-transaction.jmx_2023-10-06_164316.jtl --nongui --testfile GSMA-inbound-transaction.jmx -Dserver.rmi.ssl.disable=true --remoteexit --remotestart 172.31.26.214 >> jmeter-master.out 2>> jmeter-master.err &
trap 'kill -10 1' EXIT INT TERM
java -jar /opt/jmeter/apache-jmeter/lib/jolokia-java-agent.jar start JMeter >> jmeter-master.out 2>> jmeter-master.err
echo "Starting load test at : Fri Oct  6 16:43:16 IST 2023" && wait
