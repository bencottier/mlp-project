#/usr/bin/bash

show_help()
{
    echo "Example usage"
    echo "./transfer_data_mlp_to_local.sh -s s1556895 -m /home/s1556895/test.txt -l /Users/ff"
    echo "./transfer_data_mlp_to_local.sh --student_id s1556895 --mlp_path /home/s1556895/test.txt --local_path /Users/ff"
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

echo "STUDENT ID: ${STUDENT_ID}"
echo "MLP_PATH_FOLDER: ${MLP_PATH_FOLDER}"
echo "LOCAL_PATH: ${LOCAL_PATH}"


rsync -ua --progress ${STUDENT_ID}@mlp.inf.ed.ac.uk:${MLP_PATH_FOLDER} ${LOCAL_PATH}