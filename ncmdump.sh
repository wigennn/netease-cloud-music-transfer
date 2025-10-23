#!/bin/bash

# ncmdump_processor.sh - NCM 文件批量转换脚本
# 功能：提供多种选项来批量转换网易云音乐的NCM文件为MP3或FLAC格式

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项] [文件或目录]"
    echo "选项:"
    echo "  -h, --help          显示此帮助信息"
    echo "  -d, --directory     指定包含NCM文件的目录（默认为当前目录）"
    echo "  -f, --file          指定单个NCM文件进行转换"
    echo "  -o, --output        指定输出目录（默认为原文件所在目录）"
    echo "  -r, --recursive     递归处理子目录中的NCM文件"
    echo "  -q, --quality       设置输出质量参数（如果有的话）"
    echo "  -t, --type          设置输出格式：mp3 或 flac（默认为mp3）"
    echo "  -l, --list          只列出NCM文件，不进行实际转换"
    echo "  -v, --verbose       显示详细输出信息"
    echo "  -y, --yes           自动确认所有提示"
    echo ""
    echo "示例:"
    echo "  $0 -d ~/Music/网易云音乐 -o ~/Music/MP3 -t mp3"
    echo "  $0 -f music.ncm -t flac"
    echo "  $0 -d ~/Music -r -v"
}

# 初始化变量
INPUT_DIR="."
OUTPUT_DIR=""
RECURSIVE=false
FILE_SPECIFIED=""
OUTPUT_TYPE="mp3"
QUALITY=""
LIST_ONLY=false
VERBOSE=false
AUTO_YES=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--directory)
            INPUT_DIR="$2"
            shift
            shift
            ;;
        -f|--file)
            FILE_SPECIFIED="$2"
            shift
            shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift
            shift
            ;;
        -r|--recursive)
            RECURSIVE=true
            shift
            ;;
        -t|--type)
            OUTPUT_TYPE="$2"
            shift
            shift
            ;;
        -q|--quality)
            QUALITY="$2"
            shift
            shift
            ;;
        -l|--list)
            LIST_ONLY=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        *)
            echo "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# 检查是否安装了ncmdump
check_dependency() {
    if ! command -v ncmdump &> /dev/null; then
        echo "错误: 未找到 ncmdump 命令"
        echo "请安装 ncmdump:"
        echo " macOS: brew install ncmdump"
        echo " Windows: 从GitHub下载预编译二进制文件"
        echo " Linux: 从GitHub下载或从源码编译"
        echo ""
        echo "GitHub项目地址: https://github.com/taurusxin/ncmdump"
        exit 1
    fi
}

# 确认操作
confirm_action() {
    if [ "$AUTO_YES" = true ]; then
        return 0
    fi
    
    read -p "$1 (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# 处理单个文件
process_file() {
    local input_file="$1"
    local output_dir="$2"
    
    # 确保输入文件存在
    if [[ ! -f "$input_file" ]]; then
        echo "错误: 文件 $input_file 不存在"
        return 1
    fi
    
    # 提取文件名和目录
    local filename=$(basename -- "$input_file")
    local dirname=$(dirname -- "$input_file")
    local basefilename="${filename%.*}"
    
    # 设置输出目录
    if [[ -z "$output_dir" ]]; then
        output_dir="$dirname"
    fi
    
    # 确保输出目录存在
    mkdir -p "$output_dir"
    
    # 构建输出文件名
    local output_file="$output_dir/$basefilename.$OUTPUT_TYPE"
    
    if [ "$VERBOSE" = true ]; then
        echo "转换: $filename -> $basefilename.$OUTPUT_TYPE"
    fi
    
    # 如果是仅列出模式，不进行实际转换
    if [ "$LIST_ONLY" = true ]; then
        echo "找到: $input_file"
        return 0
    fi
    
    # 构建转换命令
    local cmd="ncmdump"
    if [[ -n "$QUALITY" ]]; then
        cmd="$cmd -q $QUALITY"
    fi
    cmd="$cmd \"$input_file\""
    
    # 执行转换命令
    if eval "$cmd"; then
        # 检查是否转换成功生成了新文件
        if [[ -f "$output_file" ]]; then
            if [ "$VERBOSE" = true ]; then
                echo "成功: $output_file"
            fi
            return 0
        else
            echo "警告: 转换完成但未找到输出文件: $output_file"
            return 1
        fi
    else
        echo "错误: 转换失败: $input_file"
        return 1
    fi
}

# 查找所有NCM文件
find_ncm_files() {
    local search_dir="$1"
    local recursive="$2"
    
    if [ "$recursive" = true ]; then
        find "$search_dir" -type f -name "*.ncm"
    else
        find "$search_dir" -maxdepth 1 -type f -name "*.ncm"
    fi
}

# 主函数
main() {
    # 检查依赖
    check_dependency
    
    # 如果指定了单个文件
    if [[ -n "$FILE_SPECIFIED" ]]; then
        if [ "$LIST_ONLY" = true ]; then
            echo "找到: $FILE_SPECIFIED"
            exit 0
        fi
        
        process_file "$FILE_SPECIFIED" "$OUTPUT_DIR"
        exit $?
    fi
    
    # 检查输入目录是否存在
    if [[ ! -d "$INPUT_DIR" ]]; then
        echo "错误: 目录 $INPUT_DIR 不存在"
        exit 1
    fi
    
    # 查找所有NCM文件
    local files=($(find_ncm_files "$INPUT_DIR" "$RECURSIVE"))
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "在 $INPUT_DIR 中未找到任何NCM文件"
        exit 0
    fi
    
    # 显示找到的文件数量
    echo "找到 ${#files[@]} 个NCM文件"
    
    # 如果是仅列出模式，退出
    if [ "$LIST_ONLY" = true ]; then
        exit 0
    fi
    
    # 确认操作
    if [ "$AUTO_YES" = false ]; then
        confirm_action "是否开始转换以上 ${#files[@]} 个文件?" || exit 0
    fi
    
    # 处理所有文件
    local success_count=0
    local fail_count=0
    
    for file in "${files[@]}"; do
        if process_file "$file" "$OUTPUT_DIR"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    done
    
    # 显示结果摘要
    echo ""
    echo "转换完成!"
    echo "成功: $success_count, 失败: $fail_count"
    
    if [[ $fail_count -gt 0 ]]; then
        exit 1
    fi
}

# 运行主函数
main "$@"
