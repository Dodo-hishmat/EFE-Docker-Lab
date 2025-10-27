pipeline {
    // 1. تحديد مكان التنفيذ
    agent any

    // 2. تعريف متغيرات هنستخدمها في المراحل الجاية
    environment {
        DOCKER_IMAGE_NAME = "nardeen/efe-docker-lab"
        CONTAINER_NAME = "efe-node-app-${BUILD_NUMBER}" // اسم فريد لكل build
    }

    // 3. المراحل الأساسية للشغلانة
    stages {


        // STAGE 1: Get the source code
        // ############ DELETE THIS ENTIRE STAGE ############
        stage('Checkout from GitHub') {
            steps {
                echo "Cloning the repository..."
                git 'https://github.com/Dodo-hishmat/EFE-Docker-Lab.git'
            }
        }
        // ##################################################
        // المرحلة الأولى: بناء صورة الدوكر
        // Jenkins هيكون نزل الكود تلقائيًا قبل ما يبدأ هنا
        stage('Build Docker Image') {
            steps {
                echo "Building the Docker image from Dockerfile..."
                // الأمر ده بيبني الصورة وبيديها اسم ورقم فريد
                sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        // المرحلة الثانية: تشغيل الكونتينر للتأكد إنه سليم
        stage('Run & Verify Container') {
            steps {
                echo "Running the container for local verification..."
                // الأمر ده بيشغل الكونتينر في الخلفية
                sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"

                echo "Waiting 15 seconds for the app to start..."
                sleep 15 // بندي للتطبيق فرصة يقوم

                echo "Verifying the application is responding..."
                // بنتأكد إن التطبيق شغال وبيرد على الشبكة
                sh "curl --fail http://localhost:3000"
            }
        }
    }

    // 4. مرحلة التنظيف (بتتنفذ في كل الحالات)
    post {
        always {
            // بننضف الكونتينر اللي عملناه عشان منسيبش حاجة شغالة
            echo "Cleaning up the test container..."
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
