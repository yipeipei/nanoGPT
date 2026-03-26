Y_TIME_STR := $(shell date +%Y-%m-%d.%H-%M-%S.%z)
Y_TIME_REPR := $(shell date +%s)

help:  # list all targets
	@egrep ^[a-zA-Z0-9_.-]+: Makefile

dated:
	TZ=Asia/Hong_Kong \
	date +%Y-%m-%d.%H-%M-%S.%z

####### END-OF-TEMPLATE

# stop
# wandb: Enter your choice:
export WANDB_MODE=offline

GPU=NVIDIA
# GPU=METAX
# GPU=ASCEND

GPT2_ARGS=\
--batch_size=8 \
--max_iters=100 --lr_decay_iters=100 \
--eval_interval=20

GPT2_NVIDIA_ARGS=${GPT2_ARGS}
GPT2_METAX_ARGS=${GPT2_ARGS}
GPT2_ASCEND_ARGS=${GPT2_ARGS} --compile=False

train-gpt2-single-gpu:
	python \
	train.py config/train_gpt2.py \
	${GPT2_${GPU}_ARGS}

train-gpt2-ddp:
	torchrun --standalone --nproc_per_node=2 \
	train.py config/train_gpt2.py \
	${GPT2_${GPU}_ARGS}
