from cnnClassifier import logger
from cnnClassifier.pipeline.stage_01_data_ingestion import DataIngestionTrainingPipeline
from cnnClassifier.pipeline.stage_02_prepare_base_model import PrepareBaseModelTrainingPipeline
from cnnClassifier.pipeline.stage_03_model_trainer import ModelTrainingPipeline
from cnnClassifier.pipeline.state_04_model_evaluation_mlflow import EvaluationPipeline

STAGE_NAME = 'Data Ingestion stage'

try:
    logger.info('*'*40)
    logger.info(f'>>>>>> stage {STAGE_NAME} started <<<<<<<')
    obj = DataIngestionTrainingPipeline()
    obj.main()
    logger.info(f'>>>>>> stage {STAGE_NAME} finished <<<<<<<')
except Exception as e:
    logger.exception(e)
    raise e


STAGE_NAME = 'Prepare base model'
try:
    logger.info('*'*40)
    logger.info(f'>>>>>> stage {STAGE_NAME} started <<<<<<<')
    prepare_base_model = PrepareBaseModelTrainingPipeline()
    prepare_base_model.main()
    logger.info(f'>>>>>> stage {STAGE_NAME} finished <<<<<<<')
except Exception as e:
    logger.exception(e)
    raise e

STAGE_NAME = 'Training'
try:
    logger.info('*'*40)
    logger.info(f'>>>>>> stage {STAGE_NAME} started <<<<<<<')
    prepare_base_model = ModelTrainingPipeline()
    prepare_base_model.main()
    logger.info(f'>>>>>> stage {STAGE_NAME} finished <<<<<<<')
except Exception as e:
    logger.exception(e)
    raise e


STAGE_NAME = 'Evaluation stage'
try:
    logger.info('*'*40)
    logger.info(f'>>>>>> stage {STAGE_NAME} started <<<<<<<')
    obj = EvaluationPipeline()
    obj.main()
    logger.info(f'>>>>>> stage {STAGE_NAME} finished <<<<<<<')
except Exception as e:
    logger.exception(e)
    raise e