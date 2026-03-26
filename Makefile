Y_TIME_STR := $(shell date +%Y-%m-%d.%H-%M-%S.%z)
Y_TIME_REPR := $(shell date +%s)

help:  # list all targets
	@egrep ^[a-zA-Z0-9_.-]+: Makefile

dated:
	TZ=Asia/Hong_Kong \
	date +%Y-%m-%d.%H-%M-%S.%z

####### END-OF-TEMPLATE

train-gpt2-ddp:
	torchrun --standalone --nproc_per_node=2 \
	train.py config/train_gpt2.py
