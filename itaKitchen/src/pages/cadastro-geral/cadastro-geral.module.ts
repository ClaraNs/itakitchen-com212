import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { CadastroGeralPage } from './cadastro-geral';

@NgModule({
  declarations: [
    CadastroGeralPage,
  ],
  imports: [
    IonicPageModule.forChild(CadastroGeralPage),
  ],
})
export class CadastroGeralPageModule {}
