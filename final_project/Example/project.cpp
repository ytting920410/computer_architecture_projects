#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

typedef struct Ref
{
    int bit[10000];
    int nru_bit;
    struct Ref *next;
}ref;

typedef struct Ref_
{
    ref *set;
    struct Ref_ *next;
}ref_list;

typedef struct fraction_
{
    int numerator, denominator;
}fraction;

int log(int x)
{
    if(x >= 1){
        int y = 0;
        while(x != 1){
            if(x % 2) x++;
            x/=2;
            y++;
        }
        return y;
    }else{
        return -1;
    }
}

int gcd(int a, int b)
{
    int r;
    while(a%b != 0){
	r = a%b;
	a = b;
	b = r;
    }
    return b;
}

ref* read_cache(ref_list* cache_sets, int num)
{
    while(num >= 0){
        cache_sets = cache_sets->next;
        if(cache_sets == NULL){
            return NULL;
        }
        num--;
    }
    return cache_sets->set;
}

bool if_hit(int a[], int b[], int len, int use_index_bit[], int bit_num, int offset)
{
    for(int q0=0; q0<len-offset; q0++){
	int c = 0;
	for(int q1=0; q1<bit_num; q1++){
	    if(q0 == use_index_bit[q1]) c = 1;
	}
	if(c == 1) continue;
        if(a[q0] != b[q0]){
            return false;
        }
    }
    return true;
}

bool put_ref_in_cache(ref* head, ref* input, int n_way, int bits_long, int use_index_bit[], int bit_num, int offset)
{
    ref* now_node = head, *replace_node = head;
    int check = 0, a = 0;
    for(int q0=0; q0<n_way; q0++){
        if(now_node->next == NULL){
            ref* new_node = new(ref);
            for(int q1=0; q1<bits_long; q1++){
                new_node->bit[q1] = input->bit[q1];
            }
            new_node->nru_bit = 0;
            new_node->next = now_node->next;
            now_node->next = new_node;
            check = 1;
	    replace_node = head;
            break;
        }else if (if_hit(now_node->next->bit, input->bit, bits_long, use_index_bit, bit_num, offset)){
	    return true;
	}else if(now_node->next->nru_bit == 1 && a == 0){
	    replace_node = now_node;
            a = 1;
        }
        now_node = now_node->next;
    }
    if(!check){
        ref* new_node = new(ref);
        for(int q1=0; q1<bits_long; q1++){
            new_node->bit[q1] = input->bit[q1];
        }
        new_node->nru_bit = 0;
        new_node->next = replace_node->next->next;
        delete(replace_node->next);
        replace_node->next = new_node;
        now_node = replace_node->next->next;
        while(now_node != NULL){
            now_node->nru_bit = 1;
            now_node = now_node->next;
        }
    }
    return false;
}

void correlation_counting(fraction** correlations, ref* head, int bits_len, int input_num)
{
    ref* now_node = head->next;
    int inputs[input_num][bits_len];
    for(int q0=0; q0<input_num; q0++){
        if(now_node != NULL){
            for(int q1=0; q1<bits_len; q1++){
                inputs[q0][q1] = now_node->bit[q1];
            }
        }else break;
        now_node = now_node->next;
    }
    //fraction correlations[bits_len][bits_len]; // [q0: num of col] [q1: num of row]
    for(int q0=0; q0<bits_len; q0++){
        for(int q1=q0; q1<bits_len; q1++){
            if(q0 == q1){
                correlations[q0][q1].numerator = 0, correlations[q0][q1].denominator = 1;
            }else{
                int identical = 0, different = 0;
                for(int q2=0; q2<input_num; q2++){
                    if(inputs[q2][q0] == inputs[q2][q1]){
                        identical++;
                    }else different++;
                }
                if(identical > different){
                    correlations[q0][q1].numerator = correlations[q1][q0].numerator = different;
                    correlations[q0][q1].denominator = correlations[q1][q0].denominator = identical;
                }else{
                correlations[q0][q1].numerator = correlations[q1][q0].numerator = identical;
                correlations[q0][q1].denominator = correlations[q1][q0].denominator = different;
                }
            }
            //printf("%d/%d ", correlations[q0][q1].numerator, correlations[q0][q1].denominator);
        }
        //printf("\n");
    }
}

int quality_init(fraction* quality, ref* head, int bits_len, int input_num)
{
    ref* now_node = head->next;
    int inputs[input_num][bits_len], best_quality = 0, best_one = 0;
    for(int q0=0; q0<input_num; q0++){
        if(now_node != NULL){
            for(int q1=0; q1<bits_len; q1++){
                inputs[q0][q1] = now_node->bit[q1];
            }
        }else break;
        now_node = now_node->next;
    }
    for(int q0=0; q0<bits_len; q0++){
        int zeros = 0, ones = 0;
        for(int q1=0; q1<input_num; q1++){
            if(inputs[q1][q0]){
                ones++;
            }else{
                zeros++;
            }
        }
        if(ones > zeros){
            quality[q0].numerator = zeros, quality[q0].denominator = ones;
        }else{
            quality[q0].numerator = ones, quality[q0].denominator = zeros;
        }
        //printf("quality of %d: %d/%d\n", q0, quality[q0].numerator, quality[q0].denominator);
        if(quality[q0].numerator > best_quality){
            best_quality = quality[q0].numerator;
            best_one = q0;
        }
    }
    return best_one;
}

int quality_calculate(fraction* quality, fraction** correlations, int bits_len, int* use_index_bit, int count)
{
    int best = 0, best_n = 0, best_d = 1, k = 1;
    while(k){
        int che = 0;
        for(int q0=0; q0<count; q0++){
            if(best == use_index_bit[q0]){
                che = 1;
                best++;
                break;
            }
        }
        if(!che){
            k = 0;
        }
    }
    for(int q0=0; q0<bits_len; q0++){
        quality[q0].numerator*=correlations[use_index_bit[count-1]][q0].numerator;
        quality[q0].denominator*=correlations[use_index_bit[count-1]][q0].denominator;
	int divide = gcd(quality[q0].numerator, quality[q0].denominator);
	quality[q0].numerator = quality[q0].numerator / divide, quality[q0].denominator = quality[q0].denominator / divide;
        //printf("quality of %d: %d/%d\n", q0, quality[q0].numerator, quality[q0].denominator);
        if(quality[q0].numerator * best_d > quality[q0].denominator * best_n){
            best = q0;
            best_n = quality[q0].numerator;
            best_d = quality[q0].denominator;
        }
    }
    return best;
}

int main(int argc, char *argv[])
{
    std::ofstream output_file(argv[3]);
    printf("checkpoint0\n");
    string a = "";// ../grading/testcases/config/
    string test_c = a + argv[1];
    string b = "";// ../grading/testcases/bench/
    string test_r = b + argv[2];
    //string c = "
    int info[4] = {0}, miss_count = 0;//test_c.c_str()
    std::ifstream file2(test_c.c_str());//"C:/Users/justi/computer_architecture_final_project/final_project/grading/testcases/config/cache1.org"
    if (!file2.is_open()) {
        std::cerr << "error\n";
	if(file2.fail()){
	    cout << "file fail" << endl;
	}
        return 1;
    }
    printf("checkpoint1\n");
    std::string line2;
    int i = 0;
    while (std::getline(file2, line2)){
	if(i==0) line2[7] = ' ';
	if(i==1||i==2) line2[5] = ' ';
        std::cout << line2 << std::endl;
	output_file << line2 << "\n";
        int len = line2.length()-1, n = 1;
        while(line2[len] != ' ' && line2[len] != '\0'){
	    if(line2[len] < '0' || line2[len] > '9'){
		--len; 
		continue;
	    }
            info[i] += (line2[len--] - '0') * n;
            n*=10;
        }
        i++;
        printf("info: %d\n", info[i-1]);
    }
    file2.close();
    int offset = log(info[1]), index_count = log(info[2]);
    //printf("%d %d\n", offset, index_count);
    ref *reference = new(ref);
    reference->next = NULL;
    std::ifstream file(test_r.c_str());//"C:/Users/justi/computer_architecture_final_project/final_project/grading/testcases/bench/reference1.lst"
    if (!file.is_open()){
        std::cerr << "error\n";
        return 1;
    }
    ref *now_node = reference;
    std::string line, first_line;
    int benchmark_output = 0, input_num = 0;
    while (std::getline(file, line)){
        if(!benchmark_output){
            first_line = line;
            benchmark_output++;
        }
        //std::cout << line << std::endl;
        if(line[0] == '0' || line[0] == '1'){
            ref *new_node = new(ref);
            new_node->next = now_node->next;
            now_node->next = new_node;
            for(int q0=0; q0<info[0]; q0++){
                now_node->next->bit[q0] = line[q0] - '0';
            }
            now_node = now_node->next;
            input_num++;
        }
    }
    file.close();
    int* use_index_bit = new int[index_count];
    fraction** correlation = new fraction*[info[0]-offset];
    for(int i = 0; i < info[0]-offset; ++i){
        correlation[i] = new fraction[info[0]-offset];
    }
    fraction* quality = new fraction[info[0]-offset];
    correlation_counting(correlation, reference, info[0]-offset, input_num);
    use_index_bit[0] = quality_init(quality, reference, info[0]-offset, input_num);
    //printf("\n");
    for(int q0=1; q0<index_count; q0++){
        use_index_bit[q0] = quality_calculate(quality, correlation, info[0]-offset, use_index_bit, q0);
        //printf("\n");
    }
    printf("\nOffset bit count: %d\n", offset);
    output_file << "\nOffset bit count: " << offset << "\n";
    printf("Indexing bit count: %d\n", index_count);
    output_file << "Indexing bit count: " << index_count << "\n";
    printf("Indexing bits:");
    output_file << "Indexing bits: ";
    for(int q0=0; q0<index_count; q0++){
        printf(" %d", info[0]-1-use_index_bit[q0]);
	output_file << " " << info[0]-1-use_index_bit[q0];
    }
    printf("\n");
    output_file << "\n";
    std::cout << std::endl << first_line << std::endl;
    output_file << "\n" << first_line << "\n";
    now_node = reference;
    ref_list *cache_sets = new(ref_list);
    cache_sets->next = NULL;
    cache_sets->set = NULL;
    for(int q0=0; q0<info[2]; q0++){
        ref_list *new_node = new(ref_list), *now_node2 = cache_sets;
        new_node->set = new(ref);
        new_node->set->next = NULL;
        new_node->next = now_node2->next;
        now_node2->next = new_node;
    }
    while(now_node->next != NULL){
        now_node = now_node->next;
        int bin = 1, num = 0;
        for(int q0=0; q0<index_count; q0++){
            num += (now_node->bit[use_index_bit[q0]] * bin);
            bin*=2;
        }
        ref* this_cache_set = read_cache(cache_sets, num);
        for(int q0=0; q0<info[0]; q0++){
            printf("%d", now_node->bit[q0]);
	    output_file << now_node->bit[q0];
        }
        if(put_ref_in_cache(this_cache_set, now_node, info[3], info[0], use_index_bit, index_count, offset)){
            printf(" hit\n");
	    output_file << " hit\n";
        }else{
            printf(" miss\n");
	    output_file << " miss\n";
            miss_count++;
        }
    }
    printf(".end\n\nTotal cache miss count: %d\n", miss_count);
    output_file << ".end\n\nTotal cache miss count: " << miss_count << "\n";
    output_file.close();
    return 0;
}
