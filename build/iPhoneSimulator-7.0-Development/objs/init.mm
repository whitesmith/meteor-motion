extern "C" {
    void ruby_sysinit(int *, char ***);
    void ruby_init(void);
    void ruby_init_loadpath(void);
    void ruby_script(const char *);
    void ruby_set_argv(int, char **);
    void rb_vm_init_compiler(void);
    void rb_vm_init_jit(void);
    void rb_vm_aot_feature_provide(const char *, void *);
    void *rb_vm_top_self(void);
    void rb_define_global_const(const char *, void *);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
void MREP_C282E085268A4967977CA821708BB37C(void *, void *);
void MREP_8D44A0BFF85A43DD8BD263B47FB1DDE1(void *, void *);
void MREP_8FD9B99D7893448F92AC2DE5FC9BD177(void *, void *);
void MREP_E22A0653521744FA9A74589381658758(void *, void *);
void MREP_7A457A00D2244CBABEBA8F349473E079(void *, void *);
void MREP_D95D7103B19649B7BEA023215D86F86A(void *, void *);
void MREP_F7D505FEA3B1427188A326A6C6776703(void *, void *);
void MREP_9AA25F5B59D44D5984D0F18AE7EAF46E(void *, void *);
void MREP_4FC0B12A0A6A4CC7B51D1B1BE2493B74(void *, void *);
void MREP_C2034E48899741F6B29C41DB724E2C8E(void *, void *);
void MREP_86ACF9D7C0EC4E7BBA6B0E7367C4DD8C(void *, void *);
void MREP_F895F7FF1CCC439F86C2F337210334BB(void *, void *);
void MREP_E08CDA22B7A44E9C86ADC25E88355418(void *, void *);
void MREP_DCCE6169627F4B2DB98918D6A003EF8B(void *, void *);
void MREP_E90E0537A53D4CCEA15EBB27AFCDC100(void *, void *);
void MREP_F63B6DA27163404EA399EAB323B0B252(void *, void *);
void MREP_6BA0FBC586794FBEB37FB4DE512AB88E(void *, void *);
void MREP_E6BDB4F272644DA78373DA2DB604B1F9(void *, void *);
void MREP_0068A0D947B1466F9D1A2D3B4C046CE6(void *, void *);
void MREP_260D85DE9C894D9499BAAD3B8F57D493(void *, void *);
void MREP_C2DFC174514A414389D129D442A89C9D(void *, void *);
void MREP_3261A9C2EC184DC786BD711AC0640C42(void *, void *);
void MREP_2AE519920E1542A087AE8043D0D19AD0(void *, void *);
void MREP_5E04EECFC11E455881F7AF069D3BF56E(void *, void *);
void MREP_D5CA5622E02F44F5AD4757A0DD643912(void *, void *);
void MREP_762004A1463345BAB44A31CCFA3D48FE(void *, void *);
void MREP_3A641D5E9CC1476C9F22BD35DD6AAE09(void *, void *);
void MREP_DB6292A1002A420094441AD794B7A506(void *, void *);
void MREP_E57CDAED8E4043B1ABC1E831D560F4CD(void *, void *);
void MREP_E4ECCDEBA6DF4B869D17BF53C35F614D(void *, void *);
void MREP_6A979AA5F60C42C585E0AE74313C08A5(void *, void *);
void MREP_085015A6A822493DB2D20FC412F27B4A(void *, void *);
void MREP_5E6CE589C62C4F8A9FED6E3CC1D32F29(void *, void *);
void MREP_2429E7F83B1F4FABBDE841F57E7C937B(void *, void *);
void MREP_6FE12198E54A40B2A5D9B3A295F3092D(void *, void *);
void MREP_0C6C15B02B9C4378A1462503FF845AD1(void *, void *);
void MREP_6D2FE600238148D1865BBE33DE2338AC(void *, void *);
}

extern "C"
void
RubyMotionInit(int argc, char **argv)
{
    static bool initialized = false;
    if (!initialized) {
	ruby_init();
	ruby_init_loadpath();
        if (argc > 0) {
	    const char *progname = argv[0];
	    ruby_script(progname);
	}
#if !__LP64__
	try {
#endif
	    void *self = rb_vm_top_self();
rb_define_global_const("RUBYMOTION_ENV", @"test");
rb_define_global_const("RUBYMOTION_VERSION", @"2.17");
MREP_C282E085268A4967977CA821708BB37C(self, 0);
MREP_8D44A0BFF85A43DD8BD263B47FB1DDE1(self, 0);
MREP_8FD9B99D7893448F92AC2DE5FC9BD177(self, 0);
MREP_E22A0653521744FA9A74589381658758(self, 0);
MREP_7A457A00D2244CBABEBA8F349473E079(self, 0);
MREP_D95D7103B19649B7BEA023215D86F86A(self, 0);
MREP_F7D505FEA3B1427188A326A6C6776703(self, 0);
MREP_9AA25F5B59D44D5984D0F18AE7EAF46E(self, 0);
MREP_4FC0B12A0A6A4CC7B51D1B1BE2493B74(self, 0);
MREP_C2034E48899741F6B29C41DB724E2C8E(self, 0);
MREP_86ACF9D7C0EC4E7BBA6B0E7367C4DD8C(self, 0);
MREP_F895F7FF1CCC439F86C2F337210334BB(self, 0);
MREP_E08CDA22B7A44E9C86ADC25E88355418(self, 0);
MREP_DCCE6169627F4B2DB98918D6A003EF8B(self, 0);
MREP_E90E0537A53D4CCEA15EBB27AFCDC100(self, 0);
MREP_F63B6DA27163404EA399EAB323B0B252(self, 0);
MREP_6BA0FBC586794FBEB37FB4DE512AB88E(self, 0);
MREP_E6BDB4F272644DA78373DA2DB604B1F9(self, 0);
MREP_0068A0D947B1466F9D1A2D3B4C046CE6(self, 0);
MREP_260D85DE9C894D9499BAAD3B8F57D493(self, 0);
MREP_C2DFC174514A414389D129D442A89C9D(self, 0);
MREP_3261A9C2EC184DC786BD711AC0640C42(self, 0);
MREP_2AE519920E1542A087AE8043D0D19AD0(self, 0);
MREP_5E04EECFC11E455881F7AF069D3BF56E(self, 0);
MREP_D5CA5622E02F44F5AD4757A0DD643912(self, 0);
MREP_762004A1463345BAB44A31CCFA3D48FE(self, 0);
MREP_3A641D5E9CC1476C9F22BD35DD6AAE09(self, 0);
MREP_DB6292A1002A420094441AD794B7A506(self, 0);
MREP_E57CDAED8E4043B1ABC1E831D560F4CD(self, 0);
MREP_E4ECCDEBA6DF4B869D17BF53C35F614D(self, 0);
MREP_6A979AA5F60C42C585E0AE74313C08A5(self, 0);
MREP_085015A6A822493DB2D20FC412F27B4A(self, 0);
MREP_5E6CE589C62C4F8A9FED6E3CC1D32F29(self, 0);
MREP_2429E7F83B1F4FABBDE841F57E7C937B(self, 0);
MREP_6FE12198E54A40B2A5D9B3A295F3092D(self, 0);
MREP_0C6C15B02B9C4378A1462503FF845AD1(self, 0);
MREP_6D2FE600238148D1865BBE33DE2338AC(self, 0);
#if !__LP64__
	}
	catch (...) {
	    rb_rb2oc_exc_handler();
	}
#endif
	initialized = true;
    }
}