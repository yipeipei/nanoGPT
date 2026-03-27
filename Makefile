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

# Test
GPT2_ARGS=\
--batch_size=8 \
--max_iters=100 --lr_decay_iters=100 \
--eval_interval=20

# Bench
# GPT2_ARGS=\
# --batch_size=8 \
# --max_iters=1000 --lr_decay_iters=1000 \
# --eval_interval=200

# Full
# GPT2_ARGS=\

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

RDZV_PORT=29700

train-gpt2-ddp-inter-node:
	export NCCL_SOCKET_IFNAME=${NCCL_SOCKET_IFNAME} && \
	torchrun --nproc_per_node=1 --nnodes=2 --node_rank=${NODE_RANK} \
	--rdzv_id=456 --rdzv_endpoint=${HOST_NODE_ADDR} \
	train.py config/train_gpt2.py \
	${GPT2_${GPU}_ARGS}

train-gpt2-ddp-inter-node-4080a:
	make train-gpt2-ddp-inter-node HOST_NODE_ADDR=10.205.1.20:${RDZV_PORT} NODE_RANK=0 NCCL_SOCKET_IFNAME=eno4np3

train-gpt2-ddp-inter-node-4080b:
	make train-gpt2-ddp-inter-node HOST_NODE_ADDR=10.205.1.20:${RDZV_PORT} NODE_RANK=1 NCCL_SOCKET_IFNAME=eno4np3

train-gpt2-fsdp1-inter-node-4080a: train-gpt2-ddp-inter-node-4080a

train-gpt2-fsdp1-inter-node-4080b: train-gpt2-ddp-inter-node-4080b
