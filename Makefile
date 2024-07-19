build_codegen:
	@flutter pub run build_runner build --delete-conflicting-outputs

dev:
	@./run_dev.sh

dev_web:
	@./run_dev_web.sh

dev_web_127:
	@flutter run -d chrome --web-port=33885 --dart-define-from-file=.env-test

get_local_ip:
	@source ~/.scripts/get_local_ip.sh

dev_web_build_to_test_localy:
	@./dev_web_build_to_test_localy.sh

build_apk_to_test_localy:
	@./build_apk_to_test_localy.sh

# StreamSink is closed Error
fix_port_block_error: 
	@flutter pub cache repair && flutter clean

send_apk_to_server:
	@sudo ssh -i ~/.ssh/zap_ass.pem ubuntu@34.230.88.183 "rm -rf /home/ubuntu/fight-gym/downloads/*" && scp -i ~/.ssh/zap_ass.pem ~/Projects/fight-gym-flutter/build/app/outputs/flutter-apk/app-release.apk ubuntu@34.230.88.183:/home/ubuntu/fight-gym/downloads/
