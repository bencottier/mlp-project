#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="calculus__differentiate"
DATADIR="data/bin/${TASK}"
EXPDIR="exp/${TASK}"
CONFIG="config-transformer-small.yml"

echo "TASK: "$TASK
echo "DATADIR: "$DATADIR
echo "EXPDIR: "$EXPDIR
echo "CONFIG: "$CONFIG

# mkdir -p $EXPDIR/{data,log,model}
# cp $DATADIR/*.pt $EXPDIR/data

# Fill in config template
cp config/${CONFIG} ${EXPDIR}/config.yml
sed -i 's,{{exp_dir}},'"${EXPDIR}"',g' ${EXPDIR}/config.yml
sed -i 's,{{data_dir}},'"${EXPDIR}"',g' ${EXPDIR}/config.yml

# Train according to config
onmt_train -config ${EXPDIR}/config.yml
