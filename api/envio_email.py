import smtplib
import ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def enviar_email(to_email: str, reset_code: str):
    from_email = "equipe@it-a-kitchen.live"
    from_password = "unifei2023."
    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = "Recuperação de senha"
    body = f"Use o código a seguir para recuperar sua senha: {reset_code}"
    msg.attach(MIMEText(body, 'plain'))

    context = ssl.create_default_context()
    server = smtplib.SMTP_SSL('smtp.titan.email', 465, context=context)
    server.set_debuglevel(1)
    server.ehlo()
    server.login(from_email, from_password)
    text = msg.as_string()
    server.sendmail(from_email, to_email, text)
    server.quit()