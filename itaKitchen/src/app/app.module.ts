import { BrowserModule } from '@angular/platform-browser';
import { ErrorHandler, NgModule } from '@angular/core';
import { IonicApp, IonicErrorHandler, IonicModule } from 'ionic-angular';
import { SplashScreen } from '@ionic-native/splash-screen';
import { StatusBar } from '@ionic-native/status-bar';

import { MyApp } from './app.component';
import { HomePage } from '../pages/home/home';
import { ShareService } from '../pages/share/share';
import { HttpClientModule } from '@angular/common/http';
import { LoginPage } from '../pages/login/login';
import { InicioPage } from '../pages/inicio/inicio';
import { CadastroClientePage } from '../pages/cadastro-cliente/cadastro-cliente';
import { CadastroEstabelecimentoPrimeiroPage } from '../pages/cadastro-estabelecimento-primeiro/cadastro-estabelecimento-primeiro';
import { CadastroEstabelecimentoSegundoPage } from '../pages/cadastro-estabelecimento-segundo/cadastro-estabelecimento-segundo';
import { CadastroGeralPage } from '../pages/cadastro-geral/cadastro-geral';
import { CadastroTipoPage } from '../pages/cadastro-tipo/cadastro-tipo';
import { CadastroHorariosPage } from '../pages/cadastro-horarios/cadastro-horarios';
import { BrMaskerModule } from 'brmasker-ionic-3';
import { File } from '@ionic-native/file';
import { IonicStorageModule } from '@ionic/storage';


@NgModule({
  declarations: [
    MyApp,
    HomePage,
    LoginPage,
    InicioPage,
    CadastroClientePage,
    CadastroEstabelecimentoPrimeiroPage,
    CadastroEstabelecimentoSegundoPage,
    CadastroGeralPage,
    CadastroTipoPage,
    CadastroHorariosPage,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    BrMaskerModule,
    IonicStorageModule.forRoot(),
    IonicModule.forRoot(MyApp)
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    MyApp,
    HomePage,
    LoginPage,
    InicioPage,
    CadastroClientePage,
    CadastroEstabelecimentoPrimeiroPage,
    CadastroEstabelecimentoSegundoPage,
    CadastroGeralPage,
    CadastroTipoPage,
    CadastroHorariosPage,
  ],
  providers: [
    StatusBar,
    ShareService,
    SplashScreen,
    File,
    {provide: ErrorHandler, useClass: IonicErrorHandler}
  ]
})
export class AppModule {}
