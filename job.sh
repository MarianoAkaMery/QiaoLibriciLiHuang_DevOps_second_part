#!/bin/bash

#SBATCH --job-name=grayscale_job           # 作业名称
#SBATCH --output=grayscale.txt             # 输出文件
#SBATCH --error=grayscale.txt              # 错误输出文件（与输出文件相同）
#SBATCH --time=0:10:00                     # 最长运行时间
#SBATCH --ntasks=1                         # 运行的任务数（进程数）
#SBATCH --nodes=1                          # 运行所需节点数
#SBATCH --partition=g100_all_serial        # 指定分区

# 加载 Singularity 模块
module load singularity

# 防止 "No Protocol specified" 警告
export HWLOC_COMPONENTS=-gl

# 创建并设置 TMPDIR（若已存在 ~/tmp 则可省略）
export TMPDIR=~/tmp
mkdir -p $TMPDIR

# 设置 MPI 所需临时目录
export OMPI_MCA_tmpdir_base=$TMPDIR
export OMPI_MCA_orte_tmpdir_base=$TMPDIR
export OMPI_MCA_plm_rsh_agent="ssh :rsh"
export OMPI_MCA_btl=self,tcp

# 设置 Singularity 缓存目录
export SINGULARITY_TMPDIR=$TMPDIR/singularity_tmp
export SINGULARITY_CACHEDIR=$TMPDIR/singularity_cache
mkdir -p $SINGULARITY_TMPDIR $SINGULARITY_CACHEDIR

# -------------------------
# 执行程序（容器已放在当前目录）
# -------------------------

singularity exec ./grayscale.sif /opt/app/build/convert_grayscale input output Average

