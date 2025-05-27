-- 创建数据库
CREATE DATABASE IF NOT EXISTS course_selection_system;
USE course_selection_system;

-- 学生表
CREATE TABLE IF NOT EXISTS student (
    student_id VARCHAR(20) PRIMARY KEY COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    age INT COMMENT '年龄',
    department VARCHAR(50) COMMENT '院系',
    major VARCHAR(50) COMMENT '专业',
    class_name VARCHAR(50) COMMENT '班级',
    password VARCHAR(100) NOT NULL DEFAULT '123456' COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话'
);

-- 教师表
CREATE TABLE IF NOT EXISTS teacher (
    teacher_id VARCHAR(20) PRIMARY KEY COMMENT '教师工号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    department VARCHAR(50) COMMENT '所属院系',
    title VARCHAR(50) COMMENT '职称',
    password VARCHAR(100) NOT NULL DEFAULT '123456' COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话'
);

-- 课程表
CREATE TABLE IF NOT EXISTS course (
    course_id VARCHAR(20) PRIMARY KEY COMMENT '课程编号',
    name VARCHAR(100) NOT NULL COMMENT '课程名称',
    credit FLOAT NOT NULL COMMENT '学分',
    hours INT COMMENT '课时',
    teacher_id VARCHAR(20) COMMENT '授课教师ID',
    description TEXT COMMENT '课程描述',
    max_students INT DEFAULT 50 COMMENT '最大选课人数',
    current_students INT DEFAULT 0 COMMENT '当前选课人数',
    syllabus TEXT COMMENT '教学大纲',
    textbook VARCHAR(255) COMMENT '教材',
    schedule_info VARCHAR(255) COMMENT '时间安排',
    status VARCHAR(50) DEFAULT 'PENDING_APPROVAL' COMMENT '课程状态 (PENDING_APPROVAL, APPROVED, REJECTED)',
    rejection_reason TEXT COMMENT '拒绝理由',
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- 选课表
CREATE TABLE IF NOT EXISTS course_selection (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL COMMENT '学生ID',
    course_id VARCHAR(20) NOT NULL COMMENT '课程ID',
    selection_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
    score FLOAT DEFAULT NULL COMMENT '成绩',
    UNIQUE KEY unique_selection (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

-- 管理员表
CREATE TABLE IF NOT EXISTS admin (
    admin_id VARCHAR(20) PRIMARY KEY COMMENT '管理员ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    password VARCHAR(100) NOT NULL DEFAULT 'admin123' COMMENT '密码'
);

-- System Configuration Table (assuming single row for simplicity)
CREATE TABLE IF NOT EXISTS system_config (
    id INT PRIMARY KEY DEFAULT 1,
    course_selection_start_time DATETIME NULL,
    course_selection_end_time DATETIME NULL,
    CONSTRAINT single_row_check CHECK (id = 1) -- Ensures only one row
);

-- Initial default config (optional)
INSERT INTO system_config (id, course_selection_start_time, course_selection_end_time)
VALUES (1, NULL, NULL)
ON DUPLICATE KEY UPDATE id=id; -- Keep existing if duplicate, or update fields if needed

-- 插入测试数据

-- 添加管理员
INSERT INTO admin (admin_id, name, password) VALUES
('admin001', '系统管理员', 'admin123');

-- 添加学生
INSERT INTO student (student_id, name, gender, age, department, major, class_name, email, phone) VALUES
('2023001', '张三', '男', 20, '计算机学院', '软件工程', '软工2301', 'zhangsan@example.com', '13800138001'),
('2023002', '李四', '女', 19, '计算机学院', '计算机科学', '计科2301', 'lisi@example.com', '13800138002'),
('2023003', '王五', '男', 21, '信息学院', '信息安全', '信安2301', 'wangwu@example.com', '13800138003'),
('2023004', '赵六', '女', 20, '计算机学院', '软件工程', '软工2302', 'zhaoliu@example.com', '13800138004'),
('2023005', '钱七', '男', 22, '信息学院', '物联网', '物联2301', 'qianqi@example.com', '13800138005');

-- 添加教师
INSERT INTO teacher (teacher_id, name, gender, department, title, email, phone) VALUES
('T001', '张教授', '男', '计算机学院', '教授', 'zhangjiaoshou@example.com', '13900139001'),
('T002', '李副教授', '女', '计算机学院', '副教授', 'lifujiaoshou@example.com', '13900139002'),
('T003', '王讲师', '男', '信息学院', '讲师', 'wangjiangshi@example.com', '13900139003');

-- 添加课程
INSERT INTO course (course_id, name, credit, hours, teacher_id, description, max_students) VALUES
('C001', '数据结构', 4.0, 64, 'T001', '计算机科学与技术专业的核心基础课程，主要研究数据的逻辑结构、存储结构及其基本操作和应用。', 60),
('C002', '算法设计与分析', 3.5, 56, 'T001', '介绍各种算法设计技术和分析方法，培养学生解决问题的能力。', 50),
('C003', '数据库系统', 4.0, 64, 'T002', '介绍数据库系统的基本概念、原理和技术，包括数据模型、关系代数、SQL语言等。', 55),
('C004', '操作系统', 3.5, 56, 'T003', '介绍操作系统的基本概念、原理和实现技术，包括进程管理、内存管理、文件系统等。', 50),
('C005', '计算机网络', 4.0, 64, 'T002', '介绍计算机网络的基本概念、体系结构和协议，包括物理层、数据链路层、网络层等。', 60);

-- 添加选课记录
INSERT INTO course_selection (student_id, course_id, selection_time, score) VALUES
('2023001', 'C001', '2023-09-01 10:00:00', 85),
('2023001', 'C003', '2023-09-01 10:30:00', 92),
('2023002', 'C001', '2023-09-01 11:00:00', 78),
('2023002', 'C002', '2023-09-01 11:30:00', 88),
('2023003', 'C003', '2023-09-02 09:00:00', 90),
('2023003', 'C004', '2023-09-02 09:30:00', 85),
('2023004', 'C002', '2023-09-02 10:00:00', 95),
('2023004', 'C005', '2023-09-02 10:30:00', 89),
('2023005', 'C004', '2023-09-03 14:00:00', 82),
('2023005', 'C005', '2023-09-03 14:30:00', 87);

-- 更新课程当前选课人数
UPDATE course c SET c.current_students = (
    SELECT COUNT(*) FROM course_selection cs WHERE cs.course_id = c.course_id
); 