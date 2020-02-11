#/usr/bin/bash

show_help()
{
    echo "Example usage"
    echo "    ./transfer_data_local_to_mlp.sh -s s1556895 -l /Users/ff/test.txt -m /home/s1556895/"
    echo "    ./transfer_data_local_to_mlp.sh --student_id s1556895 --local_path /Users/ff/test.txt --mlp_path /home/s1556895/"
    echo ""
} 

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--student_id)
    STUDENT_ID="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--mlp_path)
    MLP_PATH_FOLDER="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--local_path)
    LOCAL_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    show_help
    exit
    shift # past argument
    ;;
esac
done

if [ -z "${STUDENT_ID}" ] || [ -z "${MLP_PATH_FOLDER}" ] || [ -z "${LOCAL_PATH}" ] ; then
    echo "Provide the correct arguments"
    show_help
    exit 1
fi

echo "STUDENT ID: ${STUDENT_ID}"
echo "MLP_PATH_FOLDER: ${MLP_PATH_FOLDER}"
echo "LOCAL_PATH: ${LOCAL_PATH}"

rsync -ua --progress LOCAL_PATH ${STUDENT_ID}@mlp.inf.ed.ac.uk:${MLP_PATH_FOLDER}