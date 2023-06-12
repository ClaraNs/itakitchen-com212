import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { CadastroEstabelecimentoPrimeiroPage } from './cadastro-estabelecimento-primeiro';

@NgModule({
  declarations: [
    CadastroEstabelecimentoPrimeiroPage,
  ],
  imports: [
    IonicPageModule.forChild(CadastroEstabelecimentoPrimeiroPage),
  ],
})
export class CadastroEstabelecimentoPrimeiroPageModule {}
