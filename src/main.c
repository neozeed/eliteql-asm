/* Separate C diagnostic driver for the native assembly core. */
#include <qdos.h>
#include <qlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
long _stack=4096L;
long _mneed=2048L;
char _prog_name[]="EliteQL ASM A7";
char *_endmsg="";
typedef struct {
    const void *model;
    short x,y,z,angle,count,reserved;
    unsigned char lines[256];
} Ship;
typedef char ship_layout[(sizeof(Ship)==272)?1:-1];
extern const void *models[10];
extern unsigned projected_total,line_total;
extern void render_ship(void *,Ship *);
extern void xor_line(void *,int,int,int,int);
extern unsigned hash_screen(const void *);
static volatile unsigned ticks;
static unsigned char *backup;
static int linked,keep;
static short oldmode=-1,olddisplay=-1;
static Ship ships[12];
static unsigned char vectors[12][34];
static short matrix[9];
extern short *live_matrix;
extern void own_rotate(unsigned char *);
extern void tidy_ship(unsigned char *);
extern void scanner_reset(void *);
extern void dials_frame(void *,const unsigned char *,const unsigned char *,unsigned);
extern void energy_step(unsigned char *,unsigned);
static unsigned char bench_status[5]={255,255,255,0,0};
extern void scanner_frame(void *,unsigned char *,unsigned);
extern void move_ship(unsigned char *,const unsigned char *);
extern int motion_position(unsigned char *,short *);
static unsigned char flight_params[4]={1,0,0,40};
extern void control_step(unsigned char *,const unsigned char *);
/* Disable damping in this fixed-input benchmark: ALPHA=1, BETA=0, DELTA=0. */
static unsigned char bench_controls[13]={136,127,255,255,0,0,0,0,0,0,0,0,0};
static const unsigned char bench_keys[6]={0,0,0,0,0,0};
extern void motion_matrix(unsigned char *,short *);
static void poll_clock(void) { ticks++; }
static QL_LINK_t clock_link={0,poll_clock};
static void finish(void) {
    if(linked) { mt_rpoll(&clock_link);linked=0; }
    if(backup) {
        if(!keep) {
            mt_dmode(&oldmode,&olddisplay);
            memcpy((void *)0x20000L,backup,32768);
        }
        free(backup);backup=0;
    }
}
#ifdef ASM_DIAGNOSTICS
typedef struct { int x,y,u,v; unsigned hash; } LineCase;
typedef struct { int model,angle,x,y,z,lines,vertices; unsigned hash; } RenderCase;
#include "../tests/fixtures.h"
static int selftest(void) {
    unsigned char *mem,*screen;
    unsigned h,blank;
    unsigned i,j,bad=0;
    Ship o,p;
    mem=(unsigned char *)malloc(32784);
    if(!mem) { puts("ASM selftest: allocation failed");return 1; }
    memset(mem,0xa5,32784);screen=mem+8;
    memset(screen,0,32768);blank=hash_screen(screen);
    for(i=0;i<sizeof(line_cases)/sizeof(line_cases[0]);i++) {
        const LineCase *c=&line_cases[i];
        xor_line(screen,c->x,c->y,c->u,c->v);
        h=hash_screen(screen);
        if(h!=c->hash) { printf("FAIL line %u: %08x expected %08x\n",i,h,c->hash);bad++; }
        xor_line(screen,c->x,c->y,c->u,c->v);
        if(hash_screen(screen)!=blank) { printf("FAIL XOR reversal %u\n",i);bad++; }
        memset(screen,0,32768);
    }
    for(i=0;i<sizeof(render_cases)/sizeof(render_cases[0]);i++) {
        const RenderCase *c=&render_cases[i];
        memset(&o,0,sizeof(o));o.model=models[c->model];o.angle=c->angle;
        o.x=c->x;o.y=c->y;o.z=c->z;
        projected_total=line_total=0;
        render_ship(screen,&o);h=hash_screen(screen);
        if(h!=c->hash||o.count!=c->lines||projected_total!=(unsigned)c->vertices) {
            printf("FAIL model %u: hash %08x/%08x lines %d/%d vertices %u/%d\n",i,h,c->hash,o.count,c->lines,projected_total,c->vertices);bad++;
        }
        o.model=0;render_ship(screen,&o);
        if(hash_screen(screen)!=blank||o.count) { printf("FAIL erase %u\n",i);bad++; }
        memset(screen,0,32768);
    }
    /* Out-of-range original positions erase cached lines without losing model. */
    memset(&o,0,sizeof(o));o.model=models[4];o.z=640;o.angle=37;
    render_ship(screen,&o);h=hash_screen(screen);
    o.reserved=1;render_ship(screen,&o);
    if(hash_screen(screen)!=blank||o.count||o.model!=models[4]){puts("FAIL range hide");bad++;}
    o.reserved=0;render_ship(screen,&o);
    if(hash_screen(screen)!=h){puts("FAIL range re-entry");bad++;}
    o.model=0;render_ship(screen,&o);
    /* An overlapping object's erase must not destroy another object's pixels. */
    memset(&o,0,sizeof(o));memset(&p,0,sizeof(p));
    o.model=models[4];o.z=640;o.angle=37;
    p=o;p.model=models[5];p.x=20;
    render_ship(screen,&o);render_ship(screen,&p);
    o.angle=128;render_ship(screen,&o);
    p.model=0;render_ship(screen,&p);
    o.model=0;render_ship(screen,&o);
    if(hash_screen(screen)!=blank) { puts("FAIL overlapping cache updates");bad++; }
    /* Patterned background survives movement and hiding. */
    for(i=0;i<32768;i++)screen[i]=(unsigned char)(i*13U+7U);
    h=hash_screen(screen);memset(&o,0,sizeof(o));o.model=models[4];o.z=640;
    for(j=0;j<64;j++) { o.angle=(short)(j*4);render_ship(screen,&o); }
    o.model=0;render_ship(screen,&o);
    if(hash_screen(screen)!=h) { puts("FAIL patterned background restore");bad++; }
    for(i=0;i<8;i++)if(mem[i]!=0xa5||mem[32776+i]!=0xa5) { puts("FAIL screen bounds");bad++; }
    free(mem);
    printf("EliteQL ASM selftest: %s (%u failures; %u line / %u renderer fixtures)\n",bad?"FAIL":"PASS",bad,(unsigned)(sizeof(line_cases)/sizeof(line_cases[0])),(unsigned)(sizeof(render_cases)/sizeof(render_cases[0])));
    return bad?1:0;
}
#endif
static int bound(int v,int lo,int hi) { return v<lo?lo:v>hi?hi:v; }
int main(int argc,char **argv) {
    unsigned frames=0,start,elapsed,deadline;
    unsigned char mcnt=0;
    int i,n=1,model=4,angle=128,x=0,y=0,z=640,limit=0,bench=0,scene=0,motion=0,flight=0;
    int row1,row7,old7=0,old1=0,paused=0,done=0;
    short mode=8,display=0;
    for(i=1;i<argc;i++) {
        #ifdef ASM_DIAGNOSTICS
        if(!strcmp(argv[i],"--selftest"))return selftest();
#endif
        if(!strcmp(argv[i],"--bench"))bench=1;
        else if(!strcmp(argv[i],"--scene"))scene=1;
        else if(!strcmp(argv[i],"--motion"))motion=1;
        else if(!strcmp(argv[i],"--flight")){motion=1;flight=1;}
        else if(i+1<argc&&!strcmp(argv[i],"--frames"))limit=atoi(argv[++i]);
        else if(i+1<argc&&!strcmp(argv[i],"--fleet"))n=bound(atoi(argv[++i]),1,12);
        else if(i+1<argc&&!strcmp(argv[i],"--model"))model=bound(atoi(argv[++i]),0,9);
        else if(i+1<argc&&!strcmp(argv[i],"--angle"))angle=atoi(argv[++i])&255;
        else if(i+1<argc&&!strcmp(argv[i],"--x"))x=bound(atoi(argv[++i]),-30000,30000);
        else if(i+1<argc&&!strcmp(argv[i],"--y"))y=bound(atoi(argv[++i]),-30000,30000);
        else if(i+1<argc&&!strcmp(argv[i],"--z"))z=bound(atoi(argv[++i]),-30000,30000);
    }
    if(bench&&!limit)limit=300;
    if(scene)limit=1;
    keep=limit!=0;
    backup=(unsigned char *)malloc(32768);
    if(!backup) { puts("Cannot reserve screen restoration buffer");return 1; }
    memcpy(backup,(const void *)0x20000L,32768);
    atexit(finish);
    mt_dmode(&oldmode,&olddisplay);mt_dmode(&mode,&display);
    memset((void *)0x20000L,0,32768);
    if(flight)scanner_reset((void *)0x20000L);
    ticks=0;mt_lpoll(&clock_link);linked=1;
    for(i=0;i<n;i++) {
        ships[i].model=models[n==1?model:i%10];
        ships[i].x=(short)(n==1?x:(i%4)*450-675);
        ships[i].y=(short)(n==1?y:350-(i/4)*350);
        ships[i].z=(short)(n==1?z:2400);
        ships[i].angle=(short)((angle+i*21)&255);
        vectors[i][14]=0xe0;vectors[i][18]=vectors[i][22]=0x60;
        vectors[i][29]=vectors[i][30]=127;
        { int k;short *pos=&ships[i].x;
          for(k=0;k<3;k++){int v=pos[k];vectors[i][3*k+2]=v<0?128:0;if(v<0)v=-v;vectors[i][3*k]=(unsigned char)v;vectors[i][3*k+1]=(unsigned char)(v>>8);}
        }
    }
    start=ticks;deadline=start;
    while(!done) {
        if(!bench&&!scene) {
            row1=keyrow(1);row7=keyrow(7);
            if(row1<0)row1=0;if(row7<0)row7=0;
            if(row1&8)break;
            if((row1&64)&&!(old1&64))paused=!paused;
            if((row7&64)&&!(old7&64)) { model=(model+1)%10;ships[0].model=models[model]; }
            if(row1&2)ships[0].x=(short)bound(ships[0].x-10,-30000,30000);
            if(row1&16)ships[0].x=(short)bound(ships[0].x+10,-30000,30000);
            if(row1&4)ships[0].z=(short)bound(ships[0].z-16,16,30000);
            if(row1&128)ships[0].z=(short)bound(ships[0].z+16,16,30000);
            old1=row1;old7=row7;
        }
        if(!paused||frames==0) {
            if(flight) {
                control_step(bench_controls,bench_keys);
                flight_params[0]=bench_controls[4];
                flight_params[1]=bench_controls[5];
                flight_params[2]=bench_controls[12];
            }
            for(i=0;i<n;i++) {
                if(motion){
                    if(flight){
                        if(!(vectors[i][31]&160)&&!((mcnt^(unsigned)i)&15))tidy_ship(vectors[i]);
                        flight_params[3]=(unsigned char)((const short *)ships[i].model)[11];
                        move_ship(vectors[i],flight_params);
                        ships[i].reserved=(short)!motion_position(vectors[i],&ships[i].x);
                    }else own_rotate(vectors[i]);
                    motion_matrix(vectors[i],matrix);live_matrix=matrix;
                }
                render_ship((void *)0x20000L,&ships[i]);live_matrix=0;
            }
            if(flight)scanner_frame((void *)0x20000L,&vectors[0][0],(unsigned)n);
            if(flight) {
                energy_step(bench_status,mcnt);
                mcnt--;
                dials_frame((void *)0x20000L,bench_controls,bench_status,mcnt);
            }
            frames++;
            for(i=0;i<n;i++)ships[i].angle=(short)((ships[i].angle+1)&255);
        }
        if(limit&&frames>=(unsigned)limit)done=1;
        if(!bench&&!scene&&!done) {
            deadline+=5;
            if((int)(ticks-deadline)>0)deadline=ticks;
            while((int)(deadline-ticks)>0)mt_susjb(-1L,1,(char *)0);
        }
    }
    elapsed=ticks-start;
    finish();
    if(!scene)printf("ASM A7 mode=%d: ships=%d frames=%u ticks=%u fps=%u.%u vertices=%u lines=%u\n",flight?2:motion,n,frames,elapsed,elapsed?frames*500/elapsed/10:0,elapsed?frames*500/elapsed%10:0,projected_total,line_total);
    return 0;
}
