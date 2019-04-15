/*
 Navicat MySQL Data Transfer

 Source Server         : a
 Source Server Type    : MySQL
 Source Server Version : 80015
 Source Host           : localhost:3306
 Source Schema         : feifei

 Target Server Type    : MySQL
 Target Server Version : 80015
 File Encoding         : 65001

 Date: 15/04/2019 10:58:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for casedb
-- ----------------------------
DROP TABLE IF EXISTS `casedb`;
CREATE TABLE `casedb`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ctitle` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ctype` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cdescrible` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cresource` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rfileurl` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rfilename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cstep` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sfileurl` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sfilename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ctime` date NULL DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of casedb
-- ----------------------------
INSERT INTO `casedb` VALUES (1, '案例1', 'excel', '简述', '步骤', '', NULL, '步骤', '', NULL, '2019-04-13', '150806244');
INSERT INTO `casedb` VALUES (2, '案例2', 'word', '简述', '资源', '', NULL, '步骤', '', NULL, '2019-04-13', '150806244');

-- ----------------------------
-- Table structure for evaluatecase
-- ----------------------------
DROP TABLE IF EXISTS `evaluatecase`;
CREATE TABLE `evaluatecase`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tarid` int(3) NULL DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `econtent` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `etime` date NULL DEFAULT NULL,
  `rate` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluatecase
-- ----------------------------
INSERT INTO `evaluatecase` VALUES (1, 1, '150806244', '评论', '2019-04-13', 4);
INSERT INTO `evaluatecase` VALUES (2, 2, '150806244', '这是一个很好的案例', '2019-04-13', 5);
INSERT INTO `evaluatecase` VALUES (3, 2, '150806244', '这是评论内容', '2019-04-13', 4);
INSERT INTO `evaluatecase` VALUES (4, 1, '150806244', '评论一下', '2019-04-13', 4);
INSERT INTO `evaluatecase` VALUES (5, 1, '150806244', '我要评论', '2019-04-13', 4);

-- ----------------------------
-- Table structure for evaluateproject
-- ----------------------------
DROP TABLE IF EXISTS `evaluateproject`;
CREATE TABLE `evaluateproject`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tarid` int(11) NULL DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `econtent` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `etime` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rate` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluateproject
-- ----------------------------
INSERT INTO `evaluateproject` VALUES (1, 2, '1505111', '是', '2019-04-13', 2);
INSERT INTO `evaluateproject` VALUES (2, 2, '1505111', 's\'d\'d ', '2019-04-13', 4);
INSERT INTO `evaluateproject` VALUES (3, 1, '1505111', '是', '2019-04-13', 3);
INSERT INTO `evaluateproject` VALUES (4, 1, '1505111', '是', '2019-04-13', 5);

-- ----------------------------
-- Table structure for projectdb
-- ----------------------------
DROP TABLE IF EXISTS `projectdb`;
CREATE TABLE `projectdb`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptitle` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ptype` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pdescrible` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `presource` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rfileurl` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rfilename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pstep` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sfileurl` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sfilename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ptime` date NULL DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pimg` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projectdb
-- ----------------------------
INSERT INTO `projectdb` VALUES (1, 'flash动画入门', 'flash', '简单flash小动画', '见附件', '', NULL, '见附件', '', NULL, '2019-04-13', NULL, '');
INSERT INTO `projectdb` VALUES (2, '1', '网页布局', '1', '1', '', NULL, '1', '', NULL, '2019-04-13', NULL, '');
INSERT INTO `projectdb` VALUES (3, '1', 'js交互', '1', '1', '', NULL, '1', '', NULL, '2019-04-13', NULL, '');
INSERT INTO `projectdb` VALUES (4, '1', 'js交互', '1', '1', '', NULL, '1', '', NULL, '2019-04-13', '1505111', '');

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionurl` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `questionname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `author` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `qtime` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, 'https://www.layui.com/doc/element/icon.html', 'layui', NULL, '2019-04-13');
INSERT INTO `question` VALUES (2, '1', 'layui', NULL, '2019-04-13');
INSERT INTO `question` VALUES (3, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', NULL, '2019-04-13');
INSERT INTO `question` VALUES (4, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', NULL, '2019-04-13');
INSERT INTO `question` VALUES (5, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', NULL, '2019-04-13');
INSERT INTO `question` VALUES (6, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', NULL, '2019-04-13');
INSERT INTO `question` VALUES (7, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', NULL, '2019-04-13');
INSERT INTO `question` VALUES (8, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', '1505111', '2019-04-13');
INSERT INTO `question` VALUES (9, 'http://127.0.0.1:8848/jisuanji/wenjuanfabu.html', '问卷5', '1505111', '2019-04-13');
INSERT INTO `question` VALUES (10, 'https://www.layui.com/doc/element/icon.html', '问卷5', '1505111', '2019-04-13');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `realname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `role` int(3) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin', '294492461@qq.com', 'zhang mengdi', '信息部', 0);
INSERT INTO `user` VALUES (2, '150806242', '150806242', '294492461@qq.com', 'zhang mengdi', '15信管2', 1);
INSERT INTO `user` VALUES (3, '150806244', '150806244', '294492461@qq.com', 'zhang ', '15信管1', 1);
INSERT INTO `user` VALUES (4, '1505111', '1505111', '294492461@qq.com', 'zhang mengdi', '教学部', 2);

SET FOREIGN_KEY_CHECKS = 1;
