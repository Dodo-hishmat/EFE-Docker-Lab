// Jenkinsfile (النسخة النهائية والمضبوطة)

pipeline {
    // 1. تحديد مكان تنفيذ الأوامر (أي جهاز فاضي)
    agent any

    // 2. تعريف متغيرات هنستخدمها تحت
    environment {
        // اسم صورة الدوكر بتاعتك (ممكن تغيري 'nardeen' لاسم اليوزر بتاعك)
        DOCKER_IMAGE_NAME = "nardeen/efe-docker-lab"
        // اسم فريد للكونتينر عشان نتجنب أي تعارض
        CONTAINER_NAME = "efe-node-app-${BUILD_NUMBER}"
    }

    // 3. مراحل تنفيذ الشغلانة بالترتيب
    stages {

        // المرحلة الأولى: بناء صورة الدوكر
        // جينكينز بيكون نزل الكود تلقائيًا قبل ما يدخل هنا
        stage('Build Docker Image') {
            steps {
                echo "Building the Docker image..."
                // الأمر ده بينفذ 'docker build' في الـ Terminal
                sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        // المرحلة الثانية: تشغيل الكونتينر واختباره
        stage('Run & Verify Container') {
            steps {
                echo "Running the container for verification..."
                // بنشغل الكونتينر في الخلفية ونربط البورتات
                sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"

                echo "Waiting 15 seconds for the application to start..."
                sleep 15 // بنستنى شوية عشان نضمن إن السيرفر قام

                echo "Verifying the application is responding..."
                // بنستخدم curl عشان نتأكد إن السيرفر بيرد علينا
                sh "curl --fail http://localhost:3000"
            }
        }
    }

    // 4. مرحلة التنظيف (بتشتغل في الآخر دايماً)
    post {
        always {
            // بنمسح الكونتينر اللي عملناه عشان نحافظ على نظافة السيرفر
            echo "Cleaning up the test container..."
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
