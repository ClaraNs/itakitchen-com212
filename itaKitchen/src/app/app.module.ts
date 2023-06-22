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
import { UsuarioPage } from '../pages/usuario/usuario';
import { NovaAvaliacaoPage } from '../pages/nova-avaliacao/nova-avaliacao';
import { EditarAvaliacaoPage } from '../pages/editar-avaliacao/editar-avaliacao';
import { MinhasAvaliacoesPage } from '../pages/minhas-avaliacoes/minhas-avaliacoes';
import { EditarClientePage } from '../pages/editar-cliente/editar-cliente';
import { EditarEnderecoPage } from '../pages/editar-endereco/editar-endereco';
import { EditarEstabPage } from '../pages/editar-estab/editar-estab';
import { EditarHorarioPage } from '../pages/editar-horario/editar-horario';
import { InformacoesEstabPage } from '../pages/informacoes-estab/informacoes-estab';
import { VerAvaliacaoPage } from '../pages/ver-avaliacao/ver-avaliacao';
import { EstabAvaliacoesPage } from '../pages/estab-avaliacoes/estab-avaliacoes';
import { RelatoriosPage } from '../pages/relatorios/relatorios';


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
    UsuarioPage,
    NovaAvaliacaoPage,
    EditarAvaliacaoPage,
    MinhasAvaliacoesPage,
    EditarClientePage,
    EditarEnderecoPage,
    EditarEstabPage,
    EditarHorarioPage,
    InformacoesEstabPage,
    VerAvaliacaoPage,
    EstabAvaliacoesPage,
    RelatoriosPage
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
    UsuarioPage,
    NovaAvaliacaoPage,
    EditarAvaliacaoPage,
    MinhasAvaliacoesPage,
    EditarClientePage,
    EditarEnderecoPage,
    EditarEstabPage,
    EditarHorarioPage,
    InformacoesEstabPage,
    VerAvaliacaoPage,
    EstabAvaliacoesPage,
    RelatoriosPage
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
