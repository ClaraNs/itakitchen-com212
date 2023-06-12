import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { CadastroHorariosPage } from './cadastro-horarios';

@NgModule({
  declarations: [
    CadastroHorariosPage,
  ],
  imports: [
    IonicPageModule.forChild(CadastroHorariosPage),
  ],
})
export class CadastroHorariosPageModule {}
